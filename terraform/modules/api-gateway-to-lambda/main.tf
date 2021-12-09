terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_api_gateway_rest_api" "upload_cars_api" {
  name = local.api_name
}

resource "aws_api_gateway_resource" "object" {
  path_part   = "{object}"
  parent_id   = aws_api_gateway_rest_api.upload_cars_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.upload_cars_api.id
}

resource "aws_api_gateway_method" "postObject" {
  rest_api_id   = aws_api_gateway_rest_api.upload_cars_api.id
  resource_id   = aws_api_gateway_resource.object.id
  http_method   = "POST"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.object" = true
  }
}

resource "aws_api_gateway_method_response" "response_proxy" {
  rest_api_id = aws_api_gateway_rest_api.upload_cars_api.id
  resource_id = aws_api_gateway_resource.object.id
  http_method = aws_api_gateway_method.postObject.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.upload_cars_api.id
  resource_id             = aws_api_gateway_resource.object.id
  http_method             = aws_api_gateway_method.postObject.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda.invoke_arn
}

resource "aws_api_gateway_integration_response" "response_proxy" {
  rest_api_id = aws_api_gateway_rest_api.upload_cars_api.id
  resource_id = aws_api_gateway_resource.object.id
  http_method = aws_api_gateway_method.postObject.http_method
  status_code = aws_api_gateway_method_response.response_proxy.status_code

  depends_on = [
    aws_api_gateway_method.postObject
  ]
}

## Deployment
resource "aws_api_gateway_deployment" "upload_cars_api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.upload_cars_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.object.id,
      aws_api_gateway_method.postObject.id,
      aws_api_gateway_integration.integration.id,
      aws_api_gateway_method_response.response_proxy,
      aws_api_gateway_integration_response.response_proxy,
      aws_api_gateway_account.api_gateway_cloudwatch_account
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.upload_cars_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.upload_cars_api.id
  stage_name    = local.stage_name

  depends_on = [aws_cloudwatch_log_group.indexing_api_log_group]
}
