provider "kubernetes" {
  config_path    = var.kubeconfig_output_path
  config_context = "eks_${var.eks_cluster_name}"
}

# TODO: Replace this deployment image with Peer docker image
# TODO: Adjust resource limits and requests
resource "kubernetes_deployment" "deploy" {
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
          app        = "nginx"
          workerType = "fargate"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.irsa.metadata[0].name
        container {
          image = "nginx:1.7.8"
          name  = "nginx"
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

resource "kubernetes_service" "service" {
  metadata {
    name = "${kubernetes_deployment.deploy.metadata[0].name}-service"
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

resource "kubernetes_horizontal_pod_autoscaler" "hpa" {
  metadata {
    name = "${kubernetes_deployment.deploy.metadata[0].name}-hpa"
  }

  spec {
    min_replicas = 2
    max_replicas = 20

    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment.deploy.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }

    metric {
      type = "Resource"
      resource {
        name = "memory"
        target {
          type                = "Utilization"
          average_utilization = 70
        }
      }
    }
  }
}

resource "kubernetes_service_account" "irsa" {
  metadata {
    name      = local.service_account_name
    namespace = local.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
}
