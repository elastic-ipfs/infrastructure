
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
            name = "ADS_S3_BUCKET"
            value = "ipfs-provider-ads" # TODO: Get from variable
          }
          env {
            name = "PEER_ID_S3_BUCKET"
            value = var.configBucketName 
          }
          env {
            name = "PEER_ID_FILE"
            value = "peerId.json" 
          }
          env {
            name = "BITSWAP_PEER_MULTIADDR"
            value = "/ip4/127.0.0.1/tcp/3000/ws"
          }

          env {
            name = "SQS_PUBLISHING_QUEUE_URL"
            value = var.sqs_queue
            # value = "https://sqs.eu-west-1.amazonaws.com/505595374361/paolo-e2e-queue"
          }
          resources { // TODO: Increase resources. This is going to be a single running instance
            limits = {
              cpu    = "3"
              memory = "3Gi"
            }
            requests = {
              cpu    = "1"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}
