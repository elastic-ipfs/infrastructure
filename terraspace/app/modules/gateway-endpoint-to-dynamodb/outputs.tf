output "aws_vpc_endpoint_dynamodb" {
  value       = aws_vpc_endpoint.dynamodb
  description = "Dynamodb VPC Gateway URL"
}

output "aws_vpc_endpoint_route_table_association_dynamodb" {
  value       = aws_vpc_endpoint_route_table_association.dynamodb
  description = "Route table association of VPC and DynamoDB through gateway"
}
