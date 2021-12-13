provider "helm" {
  kubernetes {
    host                   = var.host
    token                  = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server-release"
  repository = "https://charts.bitnami.com/bitnami" # TODO: Bitnami repo var
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "nginix_ingress" {
    name      = "nginix_ingress"
    # repository = "https://kubernetes-charts.storage.googleapis.com"
    # repository = "https://helm.nginx.com/stable"
    repository = " https://charts.bitnami.com/bitnami" # TODO: Bitnami repo var
    # chart     = "nginx-stable/nginx-ingress"
    # chart     = "stable/nginx-ingress"
    # chart     = "bitnami/nginx"
    chart     = "nginx"
    namespace = "kube-system"
    verify = false
}
