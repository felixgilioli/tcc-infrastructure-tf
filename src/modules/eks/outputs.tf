output "cluster_id" {
  description = "ID do cluster EKS"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "ARN do cluster EKS"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "ID do security group do cluster EKS"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "node_group_arn" {
  description = "ARN do node group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_id" {
  description = "ID do node group"
  value       = aws_eks_node_group.main.id
}

output "cluster_iam_role_arn" {
  description = "ARN da IAM role do cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_group_iam_role_arn" {
  description = "ARN da IAM role do node group"
  value       = aws_iam_role.eks_node_group.arn
}

output "k8s_name" {
  value = aws_eks_cluster.main.name
}