# resource "kubernetes_ingress_class_v1" "aws_ipfs_ingress_class" {
#   metadata {
#     name = "aws-ipfs-ingress-class"
#     annotations = { # https://github.com/kubernetes/ingress-nginx/issues/7600
#       "ingressclass.kubernetes.io/is-default-class" = "true"
#     }
#   }

#   spec {
#     controller = "k8s.io/ingress-nginx"
#   }
# }


resource "kubernetes_ingress_v1" "aws_ipfs_ingress" {
  # wait_for_load_balancer = true
  metadata {
    name = "aws-ipfs-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "kubernetes.io/ingress.class" = "nginx"
      "ingress.kubernetes.io/rewrite-target" = "/"
      # "kubernetes.io/ingress.class" = kubernetes_ingress_class_v1.aws_ipfs_ingress_class.metadata[0].name
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
