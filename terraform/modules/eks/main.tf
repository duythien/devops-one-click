locals {
  common_tags = merge(var.common_tags, {
    TerraformModuleName = "eks-module"
  })
}

data "aws_caller_identity" "current" {}

# Data source to get the latest EKS version
data "aws_eks_cluster_auth" "main" {
  name = var.eks_cluster_name
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# IAM Role for Node Group
resource "aws_iam_role" "node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "node_eks_cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  tags = local.common_tags
}

# Security Group for EKS
resource "aws_security_group" "eks_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.eks_scaling_desired_size
    max_size     = var.eks_scaling_max_size
    min_size     = var.eks_scaling_min_size
  }

  ami_type = "AL2_x86_64"
  version  = var.eks_version

  tags = local.common_tags
}


data "tls_certificate" "oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
# EKS Cluster Addon
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.34.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
}
# AMI OIDC provider
resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.main.identity.0.oidc.0.issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

# IAM Role for Addon
resource "aws_iam_role" "ebs_csi_driver" {
  name               = "ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}
data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

  }
}
resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}


# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  depends_on       = [aws_eks_node_group.node_group]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = var.argocd_deploy_namespace
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.loadBalancerIP"
    value = "" # Leave blank for automatic IP assignment
  }

  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}

# Configure ArgoCD provider
data "kubernetes_secret" "argocd_admin_password" {
  depends_on = [helm_release.argocd]

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.argocd_deploy_namespace
  }
}
data "kubernetes_service" "argocd_server_service" {
  metadata {
    name      = "argocd-server"
    namespace = var.argocd_deploy_namespace
  }

}
provider "argocd" {
  server_addr = "${data.kubernetes_service.argocd_server_service.status.0.load_balancer.0.ingress.0.hostname}:443"
  username    = "admin"
  password    = data.kubernetes_secret.argocd_admin_password.data.password
  insecure    = true # Set to false for production
}

# Private Git repository
resource "argocd_repository" "helm_repo" {
  depends_on = [helm_release.argocd]

  repo     = var.git_repo_url
  username = var.git_repo_user
  password = var.git_repo_password
  insecure = true
}


# ArgoCD Application for Helm chart Deployment
resource "argocd_application" "app" {
  depends_on = [argocd_repository.helm_repo]

  # for_each = var.argocd_deployed_apps
  for_each = { for app in var.argocd_deployed_apps : app.app_name => app }

  metadata {
    name      = each.value.app_name
    namespace = each.value.namespace
  }

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = each.value.namespace
    }

    source {
      repo_url        = var.git_repo_url
      target_revision = "main"
      path            = each.value.chart_path

      helm {
        release_name = "${each.value.app_name}-chart"
        value_files  = [each.value.value_path]
      }
    }


    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }
}


