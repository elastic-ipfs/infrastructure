resource "kubernetes_ingress" "aws-ipfs-ingress" {
  metadata {
    name = "aws-ipfs-ingress"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = local.service_name
            service_port = local.service_port
          }
          path = "/peer/*"
        }
      }
    }

    # tls { # Termination
    #   secret_name = "tls-secret"
    # }
  }
}
