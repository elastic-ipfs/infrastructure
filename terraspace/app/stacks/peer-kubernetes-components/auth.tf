module "iam_assumable_role_admin" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  for_each                      = var.service_account_roles
  create_role                   = true
  role_name                     = each.value.role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = each.value.policies_list[*].arn
  oidc_fully_qualified_subjects = ["system:serviceaccount:${kubernetes_namespace.bitswap_peer_namespace.metadata[0].name}:${each.value.service_account_name}"]
}

resource "kubernetes_service_account" "irsa" {
  for_each = var.service_account_roles
  metadata {
    name      = each.value.service_account_name
    namespace = kubernetes_namespace.bitswap_peer_namespace.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin[each.key].iam_role_arn
    }
  }
}
