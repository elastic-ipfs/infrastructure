output "cars_api_invoke_url" {
  value = "${aws_api_gateway_deployment.cars_api_deploy.invoke_url}${aws_api_gateway_stage.v1.stage_name}/${aws_api_gateway_resource.object.path_part}"
  description = "Use this URL to PUT CAR files"
}