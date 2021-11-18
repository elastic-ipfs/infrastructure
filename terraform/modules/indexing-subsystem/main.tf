terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_s3_bucket" "cars" {
  bucket = var.carsBucketName
  acl    = "private"
}

module "api-gateway-to-s3" {
  source = "../api-gateway-to-s3"
  bucketName = var.carsBucketName
}
