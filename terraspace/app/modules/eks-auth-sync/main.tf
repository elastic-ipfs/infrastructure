terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.7.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4.1"
    }
  }
  required_version = ">= 1.0.0"
}

resource "kubernetes_config_map" "eksauth" {
  metadata {
    name      = "eks-auth-sync"
    namespace = var.namespace
  }
  data = {
    "config.yaml" = "${templatefile("${path.module}/config.yaml", { account_id = local.account_id, cluster_name = var.cluster_name })}"
  }
}


resource "kubernetes_cron_job" "eksauth" {
  metadata {
    name      = "eks-auth-sync"
    namespace = var.namespace
  }
  spec {
    schedule = var.cronjob_schedule
    job_template {
      metadata {}
      spec {
        completions                = 1
        parallelism                = 1
        backoff_limit              = 3
        active_deadline_seconds    = 120
        ttl_seconds_after_finished = 300
        template {
          metadata {}
          spec {
            container {
              name              = "eks-auth-sync"
              image             = "registry.gitlab.com/polarsquad/eks-auth-sync:${var.eks_auth_sync_version}"
              image_pull_policy = "Always"
              args              = ["-config", "/etc/eks-auth-sync/config.yaml", "-commit"]
              env {
                name  = "AWS_REGION"
                value = var.region
              }
              resources {
                requests = {
                  cpu    = "100m"
                  memory = "64Mi"
                }
                limits = {
                  cpu    = "200m"
                  memory = "128Mi"
                }
              }
              volume_mount {
                name       = "config"
                mount_path = "/etc/eks-auth-sync"
                read_only  = true
              }
            }
            restart_policy       = "Never"
            service_account_name = local.serviceAccountName
            security_context {
              run_as_non_root = true
              run_as_user     = 10101
              run_as_group    = 10101
              fs_group        = 10101
            }
            volume {
              name = "config"
              config_map {
                name = "eks-auth-sync"
              }
            }
          }
        }
      }
    }
  }
}
