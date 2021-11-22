terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_s3_bucket" "cars" {
  bucket = var.carsBucketName
  acl    = "private"
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
    
}

module "api-gateway-to-s3" {
  source = "../api-gateway-to-s3"
  bucketName = var.carsBucketName
}

module "lambda-from-s3" {
  source = "../lambda-from-s3"
  bucket = aws_s3_bucket.cars
}

module "dynamodb" {
  source = "../dynamodb"
  lambdaRoleName=module.lambda-from-s3.lambdaRoleName # TODO: Will this become a list of allowed roles?
}
