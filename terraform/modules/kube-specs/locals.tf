locals {
  service_account_namespace = "default"
  service_account_name      = "irsa"
  bitnami_repo              = "https://charts.bitnami.com/bitnami"
  peer_service_name = "${kubernetes_deployment.peer_deploy.metadata[0].name}"
  peer_service_port = 3000
  peer_service_target_port = 3000
}
