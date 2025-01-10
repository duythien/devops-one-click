# Output the EKS Cluster ARN
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

# Output the EKS Cluster ARN
output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}
