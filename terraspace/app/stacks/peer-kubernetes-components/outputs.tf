output "host" {
  value = var.host
}

output "iam_roles" {
  value = {
    for iam_role_arn, attributes in module.iam_assumable_role_admin :
    iam_role_arn => attributes.iam_role_arn
  }
}


