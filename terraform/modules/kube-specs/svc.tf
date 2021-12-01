resource "kubernetes_service" "service" {
  metadata {
    name = "${kubernetes_deployment.deploy.metadata[0].name}"
  }
  spec {
    selector = {
      app = kubernetes_deployment.deploy.metadata[0].name
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}