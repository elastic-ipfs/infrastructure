locals {
  serviceAccountName = "eks-auth-sync"
  account_id = data.aws_caller_identity.current.account_id
}
