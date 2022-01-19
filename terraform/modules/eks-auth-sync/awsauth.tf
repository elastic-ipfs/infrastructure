resource "aws_iam_policy" "eks_auth_sync_policy" {
  name        = "eks-auth-sync-policy"
  description = "Policy that enables reading of user/role tags"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListRoleTags",
            "Effect": "Allow",
            "Action": [
                "iam:ListRoleTags"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:role/*"
            ]
        },
        {
            "Sid": "ListUserTags",
            "Effect": "Allow",
            "Action": [
                "iam:ListUserTags"
            ],
            "Resource": [
                "arn:aws:iam::${local.account_id}:user/*"
            ]
        },        
        {
            "Sid": "ListRolesAndUsers",
            "Effect": "Allow",
            "Action": [
                "iam:ListRoles",
                "iam:ListUsers"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

module "iam_oidc_eks_auth_sync" { # https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-assumable-role-with-oidc 
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"
  create_role                   = true
  role_name                     = "eks-auth-sync-role"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.eks_auth_sync_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.serviceAccountName}"]
}

# TODO: Can I already try to add tags to the nodeWorker/Fargate stuff?
