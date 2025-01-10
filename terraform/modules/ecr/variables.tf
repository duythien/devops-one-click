variable "ecr_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "eks_roles_list" {
  description = "The name of the IAM role for EKS to access ECR"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "A map of common tags to assign to the resources."
  type        = map(string)
  default     = {}
}
