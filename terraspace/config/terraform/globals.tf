locals {
  # tflint-ignore: terraform_unused_declarations
  aws_account_id = "<%= expansion(':ACCOUNT') %>"
  # tflint-ignore: terraform_unused_declarations
  region         = "<%= expansion(':REGION') %>"
  # tflint-ignore: terraform_unused_declarations
  env            = "<%= expansion(':ENV') %>"  
}
