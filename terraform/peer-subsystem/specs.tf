provider "kubernetes" {
  config_path    = var.kubeconfig_output_path
  config_context = "eks_test-ipfs-aws-peer-subsystem-eks" #TODO: Get this from eks module output
}

resource "kubernetes_deployment" "nginx" {
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
