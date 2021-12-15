terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-aws-terraform-state"
    dynamodb_table = "ipfs-aws-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.dns.tfstate"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "ipfs"
  region  = "us-west-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "AWS-IPFS"
      Environment = "POC"
      Subsystem   = "DNS"
      ManagedBy   = "Terraform"
    }
  }
}

data "terraform_remote_state" "peer" {
  backend = "s3"
  config = {
    bucket = "ipfs-aws-terraform-state"
    key    = "terraform.peer.tfstate"
    region = "${local.region}"
  }
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-aws-terraform-state"
    key    = "terraform.indexing.tfstate"
    region = "${local.region}"
  }
}

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "load_balancer" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "${var.subdomain_loadbalancer}.${var.domain_name}" # TODO: Get that from ingress host?
  type    = "CNAME"
  ttl     = "300"
  records = [data.terraform_remote_state.peer.outputs.load_balancer_hostname]
}

### API Gateway

##### CERT
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  subject_alternative_names = [ "*.${var.domain_name}"] # TODO: Replace wildcard with real subdomains
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
}


resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "45m"
  }
}

#####
resource "aws_api_gateway_domain_name" "api" { 
  domain_name              = "${var.subdomain_apis}.${var.domain_name}"
  regional_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = data.terraform_remote_state.indexing.outputs.api_id
  stage_name  = data.terraform_remote_state.indexing.outputs.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}

resource "aws_route53_record" "api" {
  name    = aws_api_gateway_domain_name.api.domain_name
  type    = "A"
  zone_id = aws_route53_zone.hosted_zone.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
  }
}
