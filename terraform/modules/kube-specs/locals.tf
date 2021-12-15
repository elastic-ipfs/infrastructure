locals {
  service_account_namespace = "default"
  service_account_name      = "irsa"
  bitnami_repo              = "https://charts.bitnami.com/bitnami"
  service_name = "${kubernetes_deployment.deploy.metadata[0].name}"
  service_port = 80
  service_target_port = 80
}
