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

# TODO: Install Operator for managing admin users (Required to work properly with workflows)
# TODO: Install Prometheus
