
#####################################
# Genetal Variables
#####################################
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

#####################################
# VPC Variables
#####################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use for the VPC"
  type        = number
  default     = 2
}

#####################################
# EKS Variables
#####################################
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.30"
}
variable "eks_scaling_desired_size" {
  description = "EKS cluster Scaling config - Desired size"
  type        = number
  default     = "2"
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

variable "argocd_deployed_apps" {
  type = list(
    object({
      app_name   = string,
      namespace  = string,
      chart_path = string,
      value_path = string
    })
  )
  default = []
}
