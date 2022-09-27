provider "helm" {
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
      command     = "aws"
    }
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "prometheus"
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "15.13.0"
  create_namespace = true
  values = [
    "${file("amp_ingest_override_values.yaml")}"
  ]

  set {
    name = "serviceAccounts.server.name"
    value = var.service_account_name
  }

  set {
    name = "serviceAccounts.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.role_arn
  }

  set {
    name = "server.remoteWrite[0].url"
    value = var.remotewrite_url
  }

  set {
    name = "server.remoteWrite[0].sigv4.region"
    value = var.region
  }
}
