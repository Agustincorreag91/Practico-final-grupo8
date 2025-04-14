# Practico-final-grupo8
Repositorio creado para la ejecución del PIN Integrador Final
## Requisitos Previos

- Cuenta AWS con permisos adecuados
- AWS CLI instalado y configurado
- Terraform >= 1.0
- kubectl
- helm >= 3.0

## Guía Rápida de Implementación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/yourusername/aws-eks-monitoring-setup.git
   cd aws-eks-monitoring-setup
   ```

2. **Configurar credenciales AWS**
   ```bash
   aws configure
   ```

3. **Ejecutar el script de configuración**
   ```bash
   ./scripts/setup.sh
   ```

4. **Acceder a los servicios implementados**
   - Los endpoints se mostrarán al final del despliegue
   - También puedes consultarlos con:
     ```bash
     terraform output -state=terraform/terraform.tfstate
     ```

## Contenido Principal

### Terraform - main.tf