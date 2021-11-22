output "cars_api_invoke_url" {
  value = module.api-gateway-to-s3.cars_api_invoke_url
  description = "Use this URL to PUT CAR files"
}