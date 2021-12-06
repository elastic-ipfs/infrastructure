resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = var.route_table_id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = var.route_table_id
}
