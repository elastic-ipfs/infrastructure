terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_dynamodb_table" "blocks_table" {
  name         = var.blocks_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "multihash"
  attribute {
    name = "multihash"
    type = "S"
  }
}

resource "aws_dynamodb_table" "cars_table" {
  name         = var.cars_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "path"
  attribute {
    name = "path"
    type = "S"
  }
}
