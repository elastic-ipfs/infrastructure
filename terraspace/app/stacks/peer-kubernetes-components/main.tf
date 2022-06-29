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

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
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
  source                    = "../../modules/eks-auth-sync"
  region                    = var.region
  cluster_name              = var.cluster_id
  cluster_oidc_issuer_url   = var.cluster_oidc_issuer_url
  eks_auth_sync_role_name   = var.eks_auth_sync_role_name
  eks_auth_sync_policy_name = var.eks_auth_sync_policy_name
}

module "cluster_autoscaler" {
  source                         = "../../modules/cluster-autoscaler"
  region                         = var.region
  cluster_name                   = var.cluster_id
  cluster_oidc_issuer_url        = var.cluster_oidc_issuer_url
  cluster_autoscaler_role_name   = var.cluster_autoscaler_role_name
  cluster_autoscaler_policy_name = var.cluster_autoscaler_policy_name
}

resource "kubernetes_namespace" "bitswap_peer_namespace" {
  metadata {
    name = var.bitswap_peer_namespace
  }
}

resource "kubernetes_namespace" "logging_namespace" {
  metadata {
    name = var.logging_namespace
  }
}