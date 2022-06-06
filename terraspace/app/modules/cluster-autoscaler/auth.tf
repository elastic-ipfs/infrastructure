
data "aws_iam_policy_document" "test" {
  for_each = var.asg_names

  statement {
    actions   = ["iam:PassRole"]
    resources = [each.key]
  }
}

# TODO: FOREACH ASG_NAMES
resource "aws_iam_policy" "cluster_autoscaler" {
  # TODO: Where will I get the ASG NAME from? EKS Module.
  name        = var.cluster_autoscaler_policy_name
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
      "Resource": [ 
        "arn:aws:autoscaling:${var.region}:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/${var.asg_names[0]}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": [
        "arn:aws:autoscaling:${var.region}:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/${var.asg_names[0]}"
      ]
    }
  ]
}
EOF
}

module "iam_assumable_role_cluster_autoscaler" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = var.cluster_autoscaler_role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
}

resource "kubernetes_service_account" "irsa-autoscaler" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_cluster_autoscaler.iam_role_arn
    }
  }
}
