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
  region                    = local.region
  cluster_name              = var.cluster_id
  cluster_oidc_issuer_url   = var.cluster_oidc_issuer_url
  eks_auth_sync_version     = var.eks_auth_sync_version
  eks_auth_sync_role_name   = var.eks_auth_sync_role_name
  eks_auth_sync_policy_name = var.eks_auth_sync_policy_name
}

module "cluster_autoscaler" {
  source                         = "../../modules/cluster-autoscaler"
  region                         = local.region
  cluster_name                   = var.cluster_id
  cluster_oidc_issuer_url        = var.cluster_oidc_issuer_url
  cluster_autoscaler_version     = var.cluster_autoscaler_version
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

resource "kubernetes_manifest" "application_test" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "guestbook"
      "namespace" = "argocd"
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/argoproj/argocd-example-apps.git"
        "targetRevision" = "HEAD"
        "path"           = "guestbook"
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "guestbook"
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}


resource "kubernetes_manifest" "application_bitswap_peer" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "bitswap-peer"
      "namespace" = "argocd"
      "annotations" = {
        "notifications.argoproj.io/subscribe.on-sync-succeeded.slack" : "protocol-labs-internal-notifications"
        "notifications.argoproj.io/subscribe.on-deployed.slack" : "protocol-labs-internal-notifications"
        "notifications.argoproj.io/subscribe.on-health-degraded.slack" : "protocol-labs-internal-notifications"
        "notifications.argoproj.io/subscribe.on-sync-failed.slack" : "protocol-labs-internal-notifications"
        "notifications.argoproj.io/subscribe.on-sync-running.slack" : "protocol-labs-internal-notifications"
        "notifications.argoproj.io/subscribe.on-sync-status-unknown.slack" : "protocol-labs-internal-notifications"
      }
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/elastic-ipfs/bitswap-peer-deployment.git"
        "targetRevision" = var.bitswap_peer_deployment_branch
        "path"           = "helm"
        "helm" = {
          "releaseName" = kubernetes_namespace.bitswap_peer_namespace.metadata[0].name
          "valueFiles" = [
            "values.yaml",
            "values-${local.env}.yaml"
          ]
          "values" = {
            "service.awsCertificateArn" = var.aws_certificate_arn
          }
        }
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = kubernetes_namespace.bitswap_peer_namespace.metadata[0].name
      }
      "syncPolicy" = {
        "automated" = {
          "selfHeal" = "true"
          "prune"    = "true"
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}


resource "kubernetes_manifest" "application_fluentd" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "fluentd"
      "namespace" = "argocd"
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/elastic-ipfs/fluentd-containers-deployment.git"
        "targetRevision" = "HEAD" # TODO: Variable
        "path"           = "helm"
        "helm" = {
          "releaseName" = kubernetes_namespace.logging_namespace.metadata[0].name
          "valueFiles" = [
            "values.yaml",
            "values-${local.env}.yaml"
          ]
        }
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = kubernetes_namespace.logging_namespace.metadata[0].name
      }
      "syncPolicy" = {
        "automated" = {
          "selfHeal" = "true"
          "prune"    = "true"
        }
      }
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}
