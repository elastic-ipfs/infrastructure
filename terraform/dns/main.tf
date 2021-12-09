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

resource "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}


resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "${var.subdomain_loadbalancer}.${var.hosted_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.terraform_remote_state.peer.outputs.load_balancer_hostname]
}

# TODO: Get indexing remote state for CNAME type record. Prepare API Gateway to have a DNS to be used for Route53.
# ( Why can't I just use the basic URL and register as CNAME pointing to it?)

