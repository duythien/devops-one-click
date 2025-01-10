name                     = "interview-staging"
aws_region               = "ap-southeast-1"
vpc_cidr                 = "10.0.0.0/16"
az_count                 = 2
eks_cluster_name         = "stagingcluster"
eks_scaling_desired_size = 3
eks_scaling_max_size     = 3
eks_scaling_min_size     = 1
argocd_deploy_namespace  = "default"
argocd_version = "7.5.2"
git_repo_url = ""
git_repo_user = "duythien"

argocd_deployed_apps = [
  {
    app_name   = "mysql-database",
    namespace  = "default"
    chart_path = "Charts/mysql",
    value_path = "values/staging.yaml"
  }
]
