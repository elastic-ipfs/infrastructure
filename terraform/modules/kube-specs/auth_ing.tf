# # Policy
# data "aws_iam_policy_document" "lb_controller" {

#   statement {
#     actions = [
#       "iam:CreateServiceLinkedRole"
#     ]

#     resources = [
#       "*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "iam:AWSServiceName"

#       values = [
#         "elasticloadbalancing.amazonaws.com"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeAddresses",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeInternetGateways",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeVpcPeeringConnections",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeTags",
#       "ec2:GetCoipPoolUsage",
#       "ec2:DescribeCoipPools",
#       "elasticloadbalancing:DescribeLoadBalancers",
#       "elasticloadbalancing:DescribeLoadBalancerAttributes",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeListenerCertificates",
#       "elasticloadbalancing:DescribeSSLPolicies",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeTargetGroupAttributes",
#       "elasticloadbalancing:DescribeTargetHealth",
#       "elasticloadbalancing:DescribeTags"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "cognito-idp:DescribeUserPoolClient",
#       "acm:ListCertificates",
#       "acm:DescribeCertificate",
#       "iam:ListServerCertificates",
#       "iam:GetServerCertificate",
#       "waf-regional:GetWebACL",
#       "waf-regional:GetWebACLForResource",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL",
#       "wafv2:GetWebACL",
#       "wafv2:GetWebACLForResource",
#       "wafv2:AssociateWebACL",
#       "wafv2:DisassociateWebACL",
#       "shield:GetSubscriptionState",
#       "shield:DescribeProtection",
#       "shield:CreateProtection",
#       "shield:DeleteProtection"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:CreateSecurityGroup"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:CreateTags"
#     ]

#     resources = [
#       "arn:${var.arn_format}:ec2:*:*:security-group/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:CreateAction"

#       values = [
#         "CreateSecurityGroup"
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:CreateTags",
#       "ec2:DeleteTags"
#     ]

#     resources = [
#       "arn:${var.arn_format}:ec2:*:*:security-group/*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "true"
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:DeleteSecurityGroup"
#     ]

#     resources = [
#       "*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:CreateLoadBalancer",
#       "elasticloadbalancing:CreateTargetGroup"
#     ]

#     resources = [
#       "*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:CreateListener",
#       "elasticloadbalancing:DeleteListener",
#       "elasticloadbalancing:CreateRule",
#       "elasticloadbalancing:DeleteRule"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]

#     resources = [
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "true"
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]
#     resources = [
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:listener/net/*/*/*",
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:listener/app/*/*/*",
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:ModifyLoadBalancerAttributes",
#       "elasticloadbalancing:SetIpAddressType",
#       "elasticloadbalancing:SetSecurityGroups",
#       "elasticloadbalancing:SetSubnets",
#       "elasticloadbalancing:DeleteLoadBalancer",
#       "elasticloadbalancing:ModifyTargetGroup",
#       "elasticloadbalancing:ModifyTargetGroupAttributes",
#       "elasticloadbalancing:DeleteTargetGroup"
#     ]

#     resources = [
#       "*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false"
#       ]
#     }

#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:RegisterTargets",
#       "elasticloadbalancing:DeregisterTargets"
#     ]
#     resources = [
#       "arn:${var.arn_format}:elasticloadbalancing:*:*:targetgroup/*/*"
#     ]
#     effect = "Allow"
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:SetWebAcl",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:AddListenerCertificates",
#       "elasticloadbalancing:RemoveListenerCertificates",
#       "elasticloadbalancing:ModifyRule"
#     ]
#     resources = [
#       "*"
#     ]
#     effect = "Allow"
#   }

# }

# resource "aws_iam_policy" "lb_controller" {
#   name        = "${eks-cluster.name}-alb-ingress"
#   path        = "/"
#   description = "Policy for alb-ingress service"

#   policy = data.aws_iam_policy_document.lb_controller.json
# }

# # Role
# data "aws_iam_policy_document" "lb_controller_assume" {

#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [var.cluster_identity_oidc_issuer_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       # variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"
#       variable = "${module.iam_assumable_role_admin.provider_url}:sub"

#       values = module.iam_assumable_role_admin.oidc_fully_qualified_subjects
#       # values = [
#       #   "system:serviceaccount:${var.namespace}:${var.service_account_name}",
#       # ]
#     }

#     effect = "Allow"
#   }
# }

# resource "aws_iam_role" "lb_controller" {
#   name               = "${eks-cluster.name}-alb-ingress"
#   assume_role_policy = data.aws_iam_policy_document.lb_controller_assume.json
# }

# resource "aws_iam_role_policy_attachment" "lb_controller" {
#   role       = aws_iam_role.lb_controller.name
#   policy_arn = aws_iam_policy.lb_controller.arn
# }
