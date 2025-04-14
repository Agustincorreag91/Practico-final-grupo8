output "ec2_instance_id" {
  description = "ID de la instancia EC2"
  value       = module.ec2_instance.instance_id
}

output "ec2_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = module.ec2_instance.public_ip
}

output "eks_cluster_name" {
  description = "Nombre del clúster EKS"
  value       = module.eks_cluster.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del clúster EKS"
  value       = module.eks_cluster.cluster_endpoint
}

output "kubeconfig_command" {
  description = "Comando para configurar kubeconfig"
  value       = "aws eks update-kubeconfig --name ${module.eks_cluster.cluster_name} --region ${var.aws_region}"
}