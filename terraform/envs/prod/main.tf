
locals {
  common_tags = {
    Environment = "prod"
    Project     = "iterview"
  }
}


module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
  common_tags = local.common_tags
}

module "eks" {
  source                   = "../../modules/eks"
  eks_cluster_name         = var.eks_cluster_name
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.subnet_ids
  eks_version              = var.eks_version
  eks_scaling_desired_size = var.eks_scaling_desired_size
  eks_scaling_max_size     = var.eks_scaling_max_size
  eks_scaling_min_size     = var.eks_scaling_min_size
  argocd_deploy_namespace  = var.argocd_deploy_namespace
  argocd_version           = var.argocd_version
  git_repo_url             = var.git_repo_url
  git_repo_user            = var.git_repo_user
  git_repo_password        = var.git_repo_password
  argocd_deployed_apps     = var.argocd_deployed_apps
  common_tags              = local.common_tags
}

module "web-server-ecr" {
  source         = "../../modules/ecr"
  ecr_name       = "web-server"
  eks_roles_list = [module.eks.iam_eks_cluster_role_name, module.eks.iam_eks_nodegroup_role_name]
  common_tags    = local.common_tags
}

module "app-server-ecr" {
  source         = "../../modules/ecr"
  ecr_name       = "app-server"
  eks_roles_list = [module.eks.iam_eks_cluster_role_name, module.eks.iam_eks_nodegroup_role_name]
  common_tags    = local.common_tags
}
