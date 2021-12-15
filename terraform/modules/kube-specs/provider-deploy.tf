resource "kubernetes_deployment" "provider_deploy" {
  depends_on = [
    var.cluster_id
  ]

  metadata {
    name = local.provider_service_name
    labels = {
      app = local.provider_service_name
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.provider_service_name
      }
    }

    template {
      metadata {
        labels = {
          app        = local.provider_service_name
          workerType = "fargate"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.irsa.metadata[0].name
        container {
          image = var.provider_container_image
          name  = local.provider_service_name
          env {
            name = "NODE_ENV"
            value = "production"
          }
          env {
            name = "PORT"
            value = local.provider_service_target_port
          }
          # env {
          #   name = "PEER_ID_S3_BUCKET"
          #   value = var.peerConfigBucketName 
          # }
          # env {
          #   name = "PEER_ID_FILE"
          #   value = "peerId.json"
          # }
          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "0.5"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}
