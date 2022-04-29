terraform {
  backend "s3" {
    bucket         = "<%= expansion('ipfs-ep-terraform-state-:ACCOUNT-:REGION') %>"
    dynamodb_table = "ipfs-ep-terraform-state-lock"
    key            = "<%= expansion(':REGION/:ENV/:BUILD_DIR/terraform.tfstate') %>"
    region         = "<%= expansion(':REGION') %>"
    encrypt        = true
  }
}
