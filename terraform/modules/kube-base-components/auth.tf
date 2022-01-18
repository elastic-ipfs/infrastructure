locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "test-sa-from-interesting-module"
}
module "iam_assumable_role_admin" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"
  for_each = var.service_account_roles
  create_role                   = true
  role_name                     = each.value.role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              =  each.value.policies_list[*].arn
  oidc_fully_qualified_subjects = ["system:serviceaccount:${each.value.service_account_namespace}:${each.value.service_account_name}"]
}


##### EKS-AUTH-SYNC
module "iam_oidc_eks_auth_sync" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"
  create_role                   = true
  role_name                     = "eks-auth-sync-role"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::505595374361:policy/eks-auth-sync"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:eks-auth-sync"]
}
