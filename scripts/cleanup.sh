#!/bin/bash

set -e

echo "🧹 Iniciando limpieza de recursos..."

# Eliminar servicios Kubernetes
echo "🗑️ Eliminando recursos Kubernetes..."
kubectl delete svc nginx kibana prometheus-grafana || true
kubectl delete deployment nginx kibana || true
kubectl delete statefulset elasticsearch || true
kubectl delete daemonset fluent-bit || true
kubectl delete configmap fluent-bit-config || true
kubectl delete serviceaccount fluent-bit || true
kubectl delete clusterrole fluent-bit-role || true
kubectl delete clusterrolebinding fluent-bit-role-binding || true

# Desinstalar Helm charts
echo "🗑️ Desinstalando Helm charts..."
helm uninstall prometheus || true

# Eliminar infraestructura con Terraform
echo "🗑️ Eliminando infraestructura AWS..."
cd terraform
terraform destroy -auto-approve

echo "✅ Limpieza completada. Todos los recursos han sido eliminados."

# .github/workflows/deploy.yml
name: Deploy EKS Monitoring Infrastructure

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.3.0
    
    - name: Terraform Format
      working-directory: ./terraform
      run: terraform fmt -check
    
    - name: Terraform Init
      working-directory: ./terraform
      run: terraform init