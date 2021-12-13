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

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "ingress" {
  name      = "ingress"    
  repository = local.bitnami_repo    
  chart     = "nginx"
  namespace = "kube-system"

  set {
    name  = "ingressClassResource.enabled"
    value = "true"
  }

  set {
    name  = "ingressClassResource.default"
    value = "true"
  }

  set {
    name  = "watchIngressWithoutClass"
    value = "true"
  }
}
