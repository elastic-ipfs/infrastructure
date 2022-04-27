
output "aws_vpc_endpoint_s3" {
  value = aws_vpc_endpoint.s3
}

output "aws_vpc_endpoint_route_table_association_s3" {
  value = aws_vpc_endpoint_route_table_association.s3
}
