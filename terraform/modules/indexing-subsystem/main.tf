terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_s3_bucket" "cars" {
  bucket = var.carsBucketName
  acl    = "private"

  tags = {
    Name = var.carsBucketName
    # Environment = "Dev"
  }
}

module "api-gateway-to-s3" {
  source = "../api-gateway-to-s3"
  bucketName = var.carsBucketName
}

module "s3-to-lambda" {
  source = "../s3-to-lambda"
  bucket = aws_s3_bucket.cars
}
