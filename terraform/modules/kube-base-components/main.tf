terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.7.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.4.1"
    }
  }  
  required_version = ">= 1.0.0"
}

provider "kubernetes" {
  host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_service_account" "irsa" {
  for_each = var.service_account_roles
  metadata {
    name      = each.value.service_account_name
    namespace = each.value.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin[each.key].iam_role_arn
    }
  }
}

##### EKS-AUTH-SYNC
resource "kubernetes_service_account" "eks-auth-sync" {
  metadata {
    name      = "eks-auth-sync"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_oidc_eks_auth_sync.iam_role_arn
    }
  }
}
