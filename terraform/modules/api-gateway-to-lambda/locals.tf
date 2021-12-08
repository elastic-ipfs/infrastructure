locals {
  # api_name = format("%s-api", var.bucket.bucket)
  api_name = format("%s-api", var.lambda.function_name)
  stage_name = "v1"
}
