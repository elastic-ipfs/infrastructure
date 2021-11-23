terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_api_gateway_rest_api" "cars_api" {
  name = local.api_name
  binary_media_types = [ # About limiting to .CAR files only: https://github.com/ipld/go-car/issues/238
    "*/*"
  ]
}

resource "aws_api_gateway_resource" "object" {
  path_part   = "{object}"
  parent_id   = aws_api_gateway_rest_api.cars_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.cars_api.id
}

resource "aws_api_gateway_method" "putObject" {
  rest_api_id   = aws_api_gateway_rest_api.cars_api.id
  resource_id   = aws_api_gateway_resource.object.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.object" = true
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.cars_api.id
  resource_id = aws_api_gateway_resource.object.id
  http_method = aws_api_gateway_method.putObject.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.cars_api.id
  resource_id             = aws_api_gateway_resource.object.id
  http_method             = aws_api_gateway_method.putObject.http_method
  integration_http_method = "PUT"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.bucket.region}:s3:path/{bucket}/{key}"
  credentials             = aws_iam_role.s3_api_gateyway_role.arn
  request_parameters = {
    "integration.request.path.bucket" = "'${var.bucket.bucket}'"
    "integration.request.path.key"    = "method.request.path.object"
  }
  request_templates    = {}
  cache_key_parameters = []
}

resource "aws_api_gateway_integration_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.cars_api.id
  resource_id = aws_api_gateway_resource.object.id
  http_method = aws_api_gateway_method.putObject.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
    aws_api_gateway_method.putObject
  ]
}

## Deployment
resource "aws_api_gateway_deployment" "cars_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.cars_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.object.id,
      aws_api_gateway_method.putObject.id,
      aws_api_gateway_integration.integration.id,
      aws_api_gateway_method_response.response_200,
      aws_api_gateway_integration_response.response_200,
      aws_api_gateway_account.api_gateway_cloudwatch_account
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.cars_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.cars_api.id
  stage_name    = local.stage_name

  depends_on = [aws_cloudwatch_log_group.indexing_api_log_group]
}
