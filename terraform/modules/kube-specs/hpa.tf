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