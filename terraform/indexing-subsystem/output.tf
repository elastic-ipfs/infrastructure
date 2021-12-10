output "api_id" {
  value = module.api-gateway-to-lambda.api_id
}

output "stage_name" {
  value = module.api-gateway-to-lambda.stage_name
}

output "upload_cars_api_invoke_url" {
  value       = module.api-gateway-to-lambda.upload_cars_api_invoke_url
  description = "Use this URL to PUT CAR files"
}
