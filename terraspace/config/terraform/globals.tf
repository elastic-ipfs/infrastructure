# tflint-ignore: terraform_unused_declarations
locals {
  aws_account_id = "<%= expansion(':ACCOUNT') %>"
  env            = "<%= expansion(':ENV') %>"
}
