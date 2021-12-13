resource "kubernetes_service" "service" {
  metadata {
    name = local.service_name
  }
  spec {
    selector = {
      app = kubernetes_deployment.deploy.metadata[0].name
    }
    port {
      port        = local.service_port
      target_port = local.service_target_port
    }
    type = "ClusterIP"
  }
}
