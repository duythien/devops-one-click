# Output the ECR repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.app_ecr_repo.repository_url
}
