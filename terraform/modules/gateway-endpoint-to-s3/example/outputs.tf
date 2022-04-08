
output "aws_vpc_endpoint_s3" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_s3
}


output "aws_vpc_endpoint_route_table_association_s3" {
  value = module.gateway-endpoint-to-s3-dynamo.aws_vpc_endpoint_route_table_association_s3
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
