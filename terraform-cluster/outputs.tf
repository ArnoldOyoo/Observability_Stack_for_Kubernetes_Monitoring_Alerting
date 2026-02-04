output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID for the cluster."
  value       = module.eks.cluster_security_group_id
}

output "kubeconfig_command" {
  description = "Command to update kubeconfig for the cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
