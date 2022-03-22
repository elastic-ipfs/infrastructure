provider "helm" {
  kubernetes {
    host                   = var.host == "" ? data.terraform_remote_state.peer.outputs.host : var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_cert == "" ? data.terraform_remote_state.peer.outputs.cluster_ca_certificate : var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name == "" ? data.terraform_remote_state.peer.outputs.cluster_id : var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "prometheus_dependencies" {
  name             = "prometheus-dependencies"
  chart            = "helm/prometheus"
  namespace        = var.namespace
  create_namespace = true
  timeout          = 1800


  set {
    name = "kube-prometheus-stack.prometheus.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name = "kube-prometheus-stack.prometheus.prometheusSpec.remoteWrite[0].url"
    value = "${aws_prometheus_workspace.ipfs_elastic_provider.prometheus_endpoint}/api/v1/remote_write"
  }

  set {
    name = "kube-prometheus-stack.prometheus.prometheusSpec.remoteWrite[0].sigv4.region"
    value = var.region
  }
}

# MANUAL STEP REQUIRED to monitor kube-proxy:
# Don't forget to manually update metricsBindAddress (For now)
# TODO: follow: https://github.com/aws/containers-roadmap/issues/657
# # Can I temporarly just send the shell comand here? Or add that at workflow stage

# kubectl -n kube-system get cm kube-proxy-config -o yaml |sed 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/' | kubectl apply -f -
# kubectl -n kube-system patch ds kube-proxy -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"updateTime\":\"`date +'%s'`\"}}}}}"
