output "upload_cars_api_invoke_url" {
  value = "${aws_api_gateway_deployment.upload_cars_api_deploy.invoke_url}${aws_api_gateway_stage.v1.stage_name}/${aws_api_gateway_resource.object.path_part}"
  description = "Use this URL to get pre-signed S3 URL"
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.upload_cars_api.execution_arn
}
