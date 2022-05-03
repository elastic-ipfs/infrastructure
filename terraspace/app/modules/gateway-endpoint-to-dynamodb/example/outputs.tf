
output "aws_vpc_endpoint_dynamodb" {
  value = module.gateway-endpoint-to-dynamodb.aws_vpc_endpoint_dynamodb
}

output "aws_vpc_endpoint_route_table_association_dynamodb" {
  value = module.gateway-endpoint-to-dynamodb.aws_vpc_endpoint_route_table_association_dynamodb
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
