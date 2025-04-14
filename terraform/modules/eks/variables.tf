variable "aws_region" {
  description = "Región AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
  default     = "eks-pin-final-g8"
}

variable "instance_types" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
}

variable "key_name" {
  description = "Nombre del key pair para acceder a la instancia"
  type        = string
  default     = "pin-key.pem"
}

variable "subnet_id" {
  description = "ID del subnet donde se desplegará la instancia"
  type        = string
  default     = "test-pin"
}

variable "security_groups" {
  description = "Lista de grupos de seguridad para la instancia"
  type        = list(string)
  default     = ["pin2"]
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "EKS-Monitoring"
  }
}

variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
  default     = "cluster-pin-final-g8"
}

variable "cluster_version" {
  description = "Versión de Kubernetes para el clúster EKS"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "ID del VPC donde se desplegará el clúster"
  type        = string
  default     = "eks-vpc"
}

variable "subnet_ids" {
  description = "Lista de IDs de subnets para el clúster EKS"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "node_group_name" {
  description = "Nombre del grupo de nodos para el clúster EKS"
  type        = string
  default     = "monitoring-nodes-pin-final-g8"
}

variable "node_instance_types" {
  description = "Tipos de instancias para los nodos del clúster"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster"
  type        = number
  default     = 3
}
