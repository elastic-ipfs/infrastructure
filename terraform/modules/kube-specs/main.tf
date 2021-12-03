provider "kubernetes" {
  config_path    = var.kubeconfig_output_path
  config_context = local.config_context
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
