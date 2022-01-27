provider "helm" {
  kubernetes {
    host                   = var.host
    token                  = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server-release"
  repository = local.bitnami_repo 
  chart      = "metrics-server"
  namespace  = "kube-system"
  version = "~> 5.10"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "prometheus_dependencies" {
  name       = "prometheus-dependencies"
  chart = "../modules/kube-base-components/helm/"
  namespace  = "prometheus" 
  create_namespace = true
}
