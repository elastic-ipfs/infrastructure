# resource "aws_iam_role" "peer_subsystem_role" {
#   name = "peer_subsystem_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "policies_attach" {
#   for_each = { for policy in var.aws_iam_role_policy_list: policy.name => policy }
#   role       = aws_iam_role.peer_subsystem_role.name
#   policy_arn = each.value.arn
# }

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
  # role_policy_arns              = [var.aws_iam_role_policy_list[*].arn] # TODO: Se essa parada metida não funcionar testa com o primeiro indice (0)
  role_policy_arns              =  var.aws_iam_role_policy_list[*].arn # TODO: Se essa parada metida não funcionar testa com o primeiro indice (0)
  # role_policy_arns              = [var.aws_iam_role_policy_list[0].arn] # TODO: Se essa parada metida não funcionar testa com o primeiro indice (0)
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}
