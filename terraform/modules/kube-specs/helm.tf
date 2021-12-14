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

resource "helm_release" "aws_load_balancer" {
  name      = "aws-load-balancer"    
  repository = "https://aws.github.io/eks-charts"
  chart     = "aws-load-balancer-controller"
  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks-cluster.name
  }

  set {
    name  = "createIngressClassResource"
    value = "true"
  }

  # set {
  #   name  = "serviceAccount.create"
  #   value = "false"
  # }

  # set {
  #   name  = "serviceAccount.name"
  #   value = kubernetes_service_account.irsa.metadata[0].name
  # }
}

# resource "helm_release" "nginx_ingress" {
#   name      = "nginx-ingress"    
#   repository = "https://helm.nginx.com/stable"
#   chart     = "nginx-ingress"
#   namespace = "kube-system"
# }


# resource "helm_release" "ingress" {
#   name      = "ingress"    
#   repository = local.bitnami_repo    
#   chart     = "nginx"
#   namespace = "kube-system"

#   set {
#     name  = "ingressClassResource.enabled"
#     value = "true"
#   }

#   set {
#     name  = "ingressClassResource.default"
#     value = "true"
#   }

#   set {
#     name  = "watchIngressWithoutClass"
#     value = "true"
#   }
# }
