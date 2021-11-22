locals {
  api_name = format("%s-api", var.bucket.bucket)
  stage_name = "v1"
}
