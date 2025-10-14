# EKS Cluster Outputs
output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = module.eks.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = module.eks.cluster_version
}

output "eks_cluster_sg_id" {
  value       = aws_security_group.eks_cluster_sg.id
  description = "ID of the EKS cluster security group"
}

output "eks_node_sg_id" {
  value       = aws_security_group.eks_node_sg.id
  description = "ID of the EKS node group security group"
}