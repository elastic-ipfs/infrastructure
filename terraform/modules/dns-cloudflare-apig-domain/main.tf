terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

### API Gateway
resource "aws_api_gateway_domain_name" "api" {
  domain_name              = var.subdomain
  regional_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = var.api_gateway.api_id
  stage_name  = var.api_gateway.stage_name
  base_path   = var.api_gateway.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}
