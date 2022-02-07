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
  version    = "~> 5.10"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

# resource "helm_release" "argocd" { # TODO: Wrap it at my own helm with application specs
#   name             = "argocd"
#   chart            = "argo-cd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   version          = "~> 2.2.5"
#   namespace        = "argocd"
#   create_namespace = true
#   # timeout          = 1800
# }


resource "helm_release" "argocd" { # TODO: Wrap it at my own helm with application specs
  name             = "argocd"
  chart            = "../modules/kube-base-components/helm/argocd"
  namespace        = "argocd"
  create_namespace = true
  # timeout          = 1800
}

resource "helm_release" "prometheus_dependencies" {
  name             = "prometheus-dependencies"
  chart            = "../modules/kube-base-components/helm/prometheus"
  namespace        = "prometheus"
  create_namespace = true
  timeout          = 1800
}

# MANUAL STEP REQUIRED to monitor kube-proxy:
# Don't forget to manually update metricsBindAddress (For now)
# TODO: follow: https://github.com/aws/containers-roadmap/issues/657
# # Can I temporarly just send the shell comand here? Or add that at workflow stage

# kubectl -n kube-system get cm kube-proxy-config -o yaml |sed 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/' | kubectl apply -f -
# kubectl -n kube-system patch ds kube-proxy -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"updateTime\":\"`date +'%s'`\"}}}}}"
