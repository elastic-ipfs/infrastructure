provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_output_path
    config_context = local.config_context
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server-release"
  repository = "https://charts.bitnami.com/bitnami" 
  chart      = "metrics-server"
  namespace = "kube-system"

  set {
    name  = "apiService.create"
    value = "true"
  }
}
