provider "kubernetes" {
    # config_path            = var.kubeconfig_output_path
    # config_context         = local.config_context
    # token                  = var.token
    host                   = var.host
    cluster_ca_certificate = var.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
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
