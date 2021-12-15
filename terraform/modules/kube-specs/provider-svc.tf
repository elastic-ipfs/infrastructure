# resource "kubernetes_service" "service" {
#   metadata {
#     name = local.peer_service_name
#   }
#   spec {
#     selector = {
#       app = kubernetes_deployment.peer_deploy.metadata[0].name
#     }
#     port {
#       port        = local.peer_service_port
#       target_port = local.peer_service_target_port
#     }
#     type = "ClusterIP"
#   }
# }
