locals {
  aws_account_id = "<%= expansion(':ACCOUNT') %>"
  region         = "<%= expansion(':REGION') %>"
  env            = "<%= expansion(':ENV') %>"  
}
