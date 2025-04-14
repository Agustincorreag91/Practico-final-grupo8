provider "aws" {
  region = var.aws_region
}

# Módulo para instancia EC2
module "ec2_instance" {
  source = "./modules/ec2"
  
  instance_name    = var.instance_name
  instance_type    = var.instance_type
  ami_id           = var.ami_id
  key_name         = var.key_name
  subnet_id        = var.subnet_id
  security_groups  = var.security_groups
  
  tags = var.tags
}

# Módulo para clúster EKS
module "eks_cluster" {
  source = "./modules/eks"
  
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = var.vpc_id
  subnet_ids       = var.subnet_ids
  node_group_name  = var.node_group_name
  instance_types   = var.node_instance_types
  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size
  
  depends_on = [module.ec2_instance]
}

# Configuración de kubeconfig para acceder al clúster
resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks_cluster.cluster_name} --region ${var.aws_region}"
  }
  
  depends_on = [module.eks_cluster]
}