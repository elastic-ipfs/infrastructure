module "cloudwatch_exporter_role" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "cloudwatch-exporter"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.cloudwatch_exporter.namespace}:${local.cloudwatch_exporter.serviceaccount.name}"]
}
