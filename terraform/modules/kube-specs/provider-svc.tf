resource "kubernetes_service" "provider_service" {
  metadata {
    name = local.provider_service_name
  }
  spec {
    selector = {
      app = kubernetes_deployment.provider_deploy.metadata[0].name
    }
    port {
      port        = local.provider_service_port
      target_port = local.provider_service_target_port
    }
    type = "LoadBalancer"
  }
}
