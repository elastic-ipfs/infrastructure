terraform {
  backend "s3" {
    bucket         = "<%= expansion('tf-state-:ACCOUNT-:REGION-:ENV') %>"
    key            = "<%= expansion(':REGION/:ENV/:BUILD_DIR/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}
