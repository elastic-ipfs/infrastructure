
output "aws_vpc_endpoint_s3" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_s3
}

output "aws_vpc_endpoint_dynamodb" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_dynamodb
}

output "aws_vpc_endpoint_route_table_association_s3" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_route_table_association_s3
}

output "aws_vpc_endpoint_route_table_association_dynamodb" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_route_table_association_dynamodb
}
