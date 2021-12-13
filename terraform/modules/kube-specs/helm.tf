provider "helm" {
  kubernetes {
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

# resource "helm_release" "nginix-ingress" {
#   name      = "nginix-ingress"    
#   repository = "https://kubernetes.github.io/ingress-nginx"    
#   chart     = "ingress-nginx"
#   namespace = "kube-system"
# }

resource "helm_release" "nginix-ingress" {
  name      = "nginix-ingress"    
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart     = "stable/nginx-ingress"
  namespace = "kube-system"
}