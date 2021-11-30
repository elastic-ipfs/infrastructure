provider "kubernetes" {
  config_path    = var.kubeconfig_output_path
  config_context = "eks_${var.eks_cluster_name}"
}

# TODO: Replace this deployment image with Peer docker image
# TODO: Adjust resource limits and requests
resource "kubernetes_deployment" "nginx" {
  depends_on = [
    var.eks_cluster_id
  ]

  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
          workerType = "fargate"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.irsa-dynamodb.metadata[0].name
        container {
          # image = "nginx:1.7.8"
          # name  = "nginx"
          image = "ghcr.io/francardoso93/aws-visibility-test:latest"
          name  = "aws-visibility-test"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ngnix-service" {
  metadata {
    name = "${kubernetes_deployment.nginx.metadata[0].name}-service"
  }   
  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].name
    }
    port {
      port = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service_account" "irsa-dynamodb" {
  metadata {
    name = local.service_account_name
    namespace = local.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
}
