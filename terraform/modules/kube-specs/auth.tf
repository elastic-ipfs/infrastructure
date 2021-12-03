locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "test-sa-from-interesting-module"
}

module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"
  create_role                   = true
  role_name                     = "peer_subsystem_role"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              =  var.aws_iam_role_policy_list[*].arn
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.service_account_namespace}:${local.service_account_name}"]
}
