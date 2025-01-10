variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.30"
}

variable "eks_scaling_desired_size" {
  description = "EKS cluster Scaling config - Desired size"
  type        = number
  default     = "3"
}
variable "eks_scaling_max_size" {
  description = "EKS cluster Scaling config - Max size"
  type        = number
  default     = "3"
}
variable "eks_scaling_min_size" {
  description = "EKS cluster Scaling config - Min size"
  type        = number
  default     = "1"
}

variable "argocd_deploy_namespace" {
  description = "Kubernetes namespace to deploy ArgoCD Server"
  type        = string
  default     = "default"
}

variable "argocd_version" {
  description = "ArgoCD Server version"
  type        = string
  default     = "7.5.2"
}

variable "git_repo_url" {
  description = "URL of the Git repository containing the Helm chart"
  type        = string
}

variable "git_repo_user" {
  description = "Git User of the Git repository containing the Helm chart"
  type        = string
  default     = "git"
}

variable "git_repo_password" {
  description = "Git Password of the Git repository containing the Helm chart"
  type        = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "argocd_deployed_apps" {
  type = list(
    object({
      app_name   = string,
      namespace  = string,
      chart_path = string,
      value_path = string,
    })
  )
  default = []
}
