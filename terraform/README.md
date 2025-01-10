
# Terraform Infrastructure

This Terraform code will be deploys a K8s on AWS, provisions the ECR repository for storing container images, and sets up ArgoCD for continuous deployment.

## Prerequisites

Ensure Terraform, AWS IAM permissions, kubectl, Helm, and ArgoCD CLI are installed and configured for managing infrastructure and Kubernetes applications.

## Modules Components

### VPC Module

The VPC module creates a VPC with public subnets across multiple availability zones. An Internet Gateway is attached to the VPC to allow access to the internet.

### EKS Module

The EKS module deploys an EKS cluster along with a managed node group. The module outputs the ARNs of the IAM roles for the cluster and node group, which are later used to grant access to the ECR repository.

### ECR Module

The ECR module creates an Amazon Elastic Container Registry (ECR) repository for storing container images.

### ArgoCD

ArgoCD is installed on the EKS cluster using Helm. It is configured to automatically deploy applications based on changes in the Git repository that contains the Helm charts.


## Usage

### 1. Preparation

```
export AWS_ACCESS_KEY_ID=MyAccesskey
export AWS_SECRET_ACCESS_KEY=Mysecretkey
export TF_VAR_git_repo_password="githubpassword"

```

### 2. Clone the repository

```
git clone <repository-url> infrastructure
cd infrastructure
```

### 3. Initialize Terraform & Validate the Configuration

Initialize the Terraform env by downloading the necessary provider plugins and modules. For example to provisioing env dev

```
cd terraform/envs/dev
terraform init
terraform validate
```

### 4. Plan the Infrastructure

Run Terraform plan to review the changes that Terraform will make to your infrastructure, using environment-specific variables:

```
terraform plan -out="dev.tfplan" -var-file="vars.tfvars"
```

### 5. Apply the Configuration

Apply the Terraform configuration to create the infrastructure:

```
terraform apply "dev.tfplan"
```

### 6. Access the EKS Cluster

After the infrastructure is provisioned, you can configure your kubeconfig to interact with the EKS cluster.

```bash
aws eks --region <region> update-kubeconfig --name <cluster_name>
```

### 7. Interact with ArgoCD

ArgoCD is automatically installed by Terraform. 

You can interact with ArgoCD using the following commands:

```
argocd login
argocd app list
```

### 8. Deploy App

The Terraform code also defines ArgoCD applications for applications, you can checkout a directory helms.
