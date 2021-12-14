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

module "load_balancer_controller" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = var.cluster_oidc_issuer_url # TODO: Put that on the same EKS object? Remove the object idea?
  cluster_identity_oidc_issuer_arn = var.cluster_oidc_provider_arn 
  cluster_name                     = var.eks_cluster_id # TODO: Put that on the same EKS object? Remove the object idea?
  settings = {
    createIngressClassResource = "true"
  }
}


resource "kubernetes_ingress_v1" "aws_ipfs_ingress" {
  # wait_for_load_balancer = true
  metadata {
    name = "aws-ipfs-ingress"
    annotations = {
      # "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "ingress.kubernetes.io/rewrite-target" = "/"
      # "kubernetes.io/ingress.class" = "nginx"
      # "kubernetes.io/ingress.class" = kubernetes_ingress_class_v1.aws_ipfs_ingress_class.metadata[0].name
    }
  }

  spec {
    # ingress_class_name = kubernetes_ingress_class_v1.aws_ipfs_ingress_class.metadata[0].name
    # ingress_class_name = "nginx"
    ingress_class_name = "alb"
    
    rule {
      host = "test.clederson.com"
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

    rule {
      host = "test.franciscocardosotest.com"
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
