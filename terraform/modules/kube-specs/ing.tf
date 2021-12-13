resource "kubernetes_ingress_v1" "aws_ipfs_ingress" {
  # wait_for_load_balancer = true
  metadata {
    name = "aws-ipfs-ingress"
    annotations = {
      "ingress.kubernetes.io/rewrite-target" : "/"
    }
  }

  spec {
    # ingress_class_name = kubernetes_ingress_class_v1.aws_ipfs_ingress_class.metadata[0].name
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = local.service_name
        port {
          number = local.service_port
        }
      }
    }
    rule {
      http {
        path {
          backend {
            service {
              name = local.service_name
              port {
                number = local.service_port
              }
            }
          }
          path      = "/peer"
          path_type = "Prefix"
        }
      }
    }

    # tls { # Termination
    #   secret_name = "tls-secret"
    # }
  }
}
