output "cars_api_invoke_url" {
  value = aws_api_gateway_deployment.cars_api_deploy.invoke_url
  description = "Use this URL to PUT CAR files"
}