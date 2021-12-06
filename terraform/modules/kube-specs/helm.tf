provider "helm" {
  # TODO: Read from the same object that configures Kubernetes
  kubernetes {
    # config_path            = var.kubeconfig_output_path
    # config_context         = local.config_context
    host                   = var.host
    token                  = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "apiService.create"
    value = "true"
  }
}
