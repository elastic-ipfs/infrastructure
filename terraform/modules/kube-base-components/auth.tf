locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "test-sa-from-interesting-module"
}

module "iam_assumable_role_admin" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  for_each                      = var.service_account_roles
  create_role                   = true
  role_name                     = each.value.role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = each.value.policies_list[*].arn
  oidc_fully_qualified_subjects = ["system:serviceaccount:${each.value.service_account_namespace}:${each.value.service_account_name}"]
}

resource "kubernetes_service_account" "irsa" {
  for_each = var.service_account_roles
  metadata {
    name      = each.value.service_account_name
    namespace = each.value.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin[each.key].iam_role_arn
    }
  }
}

## Cluster Autoscaler

resource "aws_iam_policy" "cluster_autoscaller" {
  name        = "eks-cluster-autoscaller-policy"
  description = "Policy for allowing Kubernetes to autoscale nodes"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
} # TODO: Minimal policy: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md

module "iam_assumable_role_cluster_autoscaler" { 
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "IPFSClusterEKSAutoscalerRole"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
}

resource "kubernetes_service_account" "irsa-autoscaller" {
  metadata {
    name      = "cluster-autoscaler" # TODO: Local variable
    namespace = "kube-system" # TODO: Local variable
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_cluster_autoscaler.iam_role_arn
    }
  }
}
