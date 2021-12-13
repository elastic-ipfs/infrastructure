resource "kubernetes_deployment" "deploy" {
  depends_on = [
    var.eks_cluster_id
  ]

  metadata {
    name = "aws-ipfs-bitswap-peer"
    labels = {
      app = "aws-ipfs-bitswap-peer"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "aws-ipfs-bitswap-peer"
      }
    }

    template {
      metadata {
        labels = {
          app        = "aws-ipfs-bitswap-peer"
          workerType = "fargate"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.irsa.metadata[0].name
        container {
          image = "nginx"
          # image = var.container_image
          name  = "aws-ipfs-bitswap-peer"
          env {
            name = "NODE_ENV"
            value = "production"
          }
          env {
            name = "PORT"
            value = "3000"
          }
           env {
            name = "PEER_ID_S3_BUCKET"
            value = var.peerConfigBucketName 
          }
          env {
            name = "PEER_ID_FILE"
            value = "peerId.json"
          }
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
