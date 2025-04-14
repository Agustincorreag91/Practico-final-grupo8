variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
}

variable "key_name" {
  description = "Nombre del key pair para acceder a la instancia"
  type        = string
}

variable "subnet_id" {
  description = "ID del subnet donde se desplegará la instancia"
  type        = string
}

variable "security_groups" {
  description = "Lista de grupos de seguridad para la instancia"
  type        = list(string)
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {}
}