provider "helm" {
  kubernetes {
    host = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
      command     = "aws"
    }
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server-release"
  repository = local.bitnami_repo
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "~> 5.10"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "argocd" {
  count            = var.deploy_argocd ? 1 : 0
  name             = "argocd"
  chart            = "./helm/argocd"
  namespace        = "argocd"
  create_namespace = true
}
