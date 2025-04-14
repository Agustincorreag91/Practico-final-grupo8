#!/bin/bash

set -e

echo "🚀 Iniciando despliegue de infraestructura EKS con monitoreo..."

# Validar requisitos previos
echo "✅ Verificando requisitos previos..."
command -v aws >/dev/null 2>&1 || { echo "❌ AWS CLI no está instalado. Abortando."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform no está instalado. Abortando."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl no está instalado. Abortando."; exit 1; }
command -v helm >/dev/null 2>&1 || { echo "❌ Helm no está instalado. Abortando."; exit 1; }

# Verificar autenticación AWS
echo "✅ Verificando credenciales AWS..."
aws sts get-caller-identity >/dev/null 2>&1 || { echo "❌ No se pudo autenticar con AWS. Ejecute 'aws configure' primero."; exit 1; }

# Desplegar infraestructura con Terraform
echo "🔧 Desplegando infraestructura AWS con Terraform..."
cd terraform
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

# Recuperar información del clúster
CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")
echo "✅ Clúster EKS '${CLUSTER_NAME}' creado en la región '${REGION}'."

# Configurar kubectl
echo "🔧 Configurando kubectl para el clúster EKS..."
aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION}
kubectl get nodes

# Desplegar Nginx
echo "🔧 Desplegando Nginx en el clúster..."
cd ../kubernetes/nginx
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Esperar a que Nginx esté listo
echo "⏳ Esperando a que los pods de Nginx estén listos..."
kubectl wait --for=condition=ready pod -l app=nginx --timeout=120s

# Desplegar stack EFK
echo "🔧 Desplegando Elasticsearch, FluentBit y Kibana..."
cd ../monitoring/elastic-stack
kubectl apply -f elasticsearch.yaml
kubectl apply -f elasticsearch-service.yaml
kubectl apply -f kibana.yaml
kubectl apply -f kibana-service.yaml
kubectl apply -f fluent-bit-config.yaml
kubectl apply -f fluent-bit-rbac.yaml
kubectl apply -f fluent-bit.yaml

# Esperar a que Elasticsearch esté listo
echo "⏳ Esperando a que Elasticsearch esté listo..."
kubectl wait --for=condition=ready pod -l app=elasticsearch --timeout=300s

# Desplegar Prometheus y Grafana usando Helm
echo "🔧 Desplegando Prometheus y Grafana..."
cd ../prometheus-grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -f prometheus-values.yaml

# Esperar a que Grafana esté listo
echo "⏳ Esperando a que Grafana esté listo..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana --timeout=180s

# Obtener URLs de acceso
echo "🔍 Obteniendo URLs de acceso..."
cd ../../..

NGINX_URL=$(kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
KIBANA_URL=$(kubectl get svc kibana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
GRAFANA_URL=$(kubectl get svc prometheus-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "✅ ¡Despliegue completado!"
echo "📊 URLs de acceso:"
echo "- Nginx: http://${NGINX_URL}"
echo "- Kibana: http://${KIBANA_URL}:5601"
echo "- Grafana: http://${GRAFANA_URL}"
echo "  - Usuario: admin"
echo "  - Contraseña: admin"

echo "📝 Para limpiar todos los recursos, ejecute: ./scripts/cleanup.sh"