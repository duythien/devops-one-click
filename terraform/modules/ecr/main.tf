# Create an ECR repository
resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  tags = var.common_tags
}

# Define Custom IAM Policy for ECR Access
data "aws_iam_policy_document" "ecr_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      aws_ecr_repository.app_ecr_repo.arn,
      "${aws_ecr_repository.app_ecr_repo.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

# Attach Custom Policy to EKS Cluster Roles
resource "aws_iam_policy" "ecr_access_policy" {
  name        = "${var.ecr_name}-ecr-access-policy"
  description = "Custom policy for ECR access by EKS roles"
  policy      = data.aws_iam_policy_document.ecr_access_policy.json

  tags = var.common_tags
}
resource "aws_iam_role_policy_attachment" "attach_ecr_policy_to_eks_roles" {
  count      = length(var.eks_roles_list)
  role       = var.eks_roles_list[count.index]
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

