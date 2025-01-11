terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.2.0"
    }
  }
}
