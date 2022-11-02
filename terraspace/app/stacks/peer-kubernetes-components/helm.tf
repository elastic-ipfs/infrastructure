provider "helm" {
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
      command     = "aws"
    }
  }
}

resource "helm_release" "metric_server" {
  name       = "metric-server-release"
  repository = local.bitnami_repo
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "~> ${var.metrics_server_version}"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "argocd" {
  name             = "argo-cd"
  chart            = "argo-cd"
  version          = "~> 5.6.2" # TODO: Variable
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argocd-rollouts"
  create_namespace = true
}

resource "helm_release" "argocd_rollouts" {
  name             = "argo-rollouts"
  chart            = "argo-rollouts"
  version          = "~> 2.21.1" # TODO: Variable
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argocd-rollouts"
  create_namespace = true

  set {
    name  = "dashboard.enabled"
    value = true
  }
}
