
# EKS Module

The EKS module deploys an EKS cluster along with a managed node group. The module outputs the ARNs of the IAM roles for the cluster and node group, which are later used to grant access to the ECR repository.

## EKS Variables

- **`eks_cluster_name`**: Name of the EKS cluster.
- **`eks_version`**: Version of the EKS cluster (default: `1.30`).
- **`argocd_deploy_namespace`**: Kubernetes namespace to deploy ArgoCD (default: `default`).
- **`argocd_version`**: Version of ArgoCD (default: `7.5.2`).
- **`git_repo_url`**: URL of the Git repository containing the Helm chart.
- **`git_repo_user`**: Username for the Git repository containing the Helm chart.
- **`git_repo_password`**: Password for the Git repository containing the Helm chart. This variable should not put in .tfvars files, it can be defined in OS env var by `export TF_VAR_git_repo_password=[password]`
- **`argocd_deployed_apps`**: List of ArgoCD applications to be deployed. Each object includes `app_name`, `namespace`, `chart_path`, and `value_path`.


## EKS Auto-Scaling Variables

These are variables configure the desired, minimum, and maximum sizes for the EKS cluster's auto-scaling group:

- **`eks_scaling_desired_size`**: The desired size of the EKS cluster (default: `3`).
- **`eks_scaling_max_size`**: The maximum size of the EKS cluster (default: `3`).
- **`eks_scaling_min_size`**: The minimum size of the EKS cluster (default: `3`).