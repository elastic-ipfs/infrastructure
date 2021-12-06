provider "helm" {
  # TODO: Read from the same object that configures Kubernetes
  kubernetes {
    # config_path            = var.kubeconfig_output_path
    # config_context         = local.config_context
    # token                  = var.token
    host                   = var.host
    cluster_ca_certificate = var.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
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
