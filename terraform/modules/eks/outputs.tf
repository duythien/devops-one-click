# Output the EKS Cluster ARN
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

# Output the EKS Cluster ARN
output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

# Output the EKS NodeGroup ARN
output "node_group_arn" {
  value = aws_eks_node_group.node_group.arn
}

# Output the EKS Cluster IAM Role ARN
output "iam_eks_cluster_role_name" {
  value = aws_iam_role.eks_role.name
}
# Output the EKS NodeGroup IAM Role ARN
output "iam_eks_nodegroup_role_name" {
  value = aws_iam_role.node_role.name
}
