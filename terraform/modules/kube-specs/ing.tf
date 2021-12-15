module "load_balancer_controller" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = var.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = var.cluster_oidc_provider_arn
  cluster_name                     = var.cluster_id
  settings = {
    createIngressClassResource = "true"
  }
}

resource "kubernetes_ingress_v1" "aws_ipfs_ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "aws-ipfs-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/load-balancer-attributes": "access_logs.s3.enabled=true,access_logs.s3.bucket=ipfs-ilb-logs,access_logs.s3.prefix=lb"
      # "ingress.kubernetes.io/rewrite-target" = "/"  # Does not work with AWS ALB Ingress (https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/1571)
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "peer.franciscocardosotest.com"
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
          path      = "/"
          path_type = "Prefix"
        }
      }
    }

    rule {
      host = "provider.franciscocardosotest.com"
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
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}
