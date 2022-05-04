terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.7.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4.1"
    }

  }
  required_version = ">= 1.0.0"
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
    command     = "aws"
  }
}

module "eks_auth_sync" {
  count                   = var.deploy_eks_auth_sync ? 1 : 0
  source                  = "../../modules/eks-auth-sync"
  region                  = var.region
  cluster_name            = var.cluster_id
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
}

module "cluster_autoscaler" {
  count                   = var.deploy_cluster_autoscaler ? 1 : 0
  source                  = "../../modules/cluster-autoscaler"
  region                  = var.region
  cluster_name            = var.cluster_id
  cluster_oidc_issuer_url = var.cluster_oidc_issuer_url
}
