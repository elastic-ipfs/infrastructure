terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team       = "NearForm"
      Project    = "AWS-IPFS"
      ManagedBy  = "Terraform"
      Example    = "true"
      Production = "false"
    }
  }
}

module "dynamodb" {
  source = "../"
  blocks_table = {
    name = var.blocks_table.name
  }
  cars_table = {
    name = var.cars_table.name
  }
}
