resource "kubernetes_service" "service" {
  metadata {
    name = "${kubernetes_deployment.deploy.metadata[0].name}"
  }
  spec {
    selector = {
      app = kubernetes_deployment.deploy.metadata[0].name
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}