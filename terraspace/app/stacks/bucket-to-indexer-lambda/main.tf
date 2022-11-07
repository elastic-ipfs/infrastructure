terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-ep-terraform-state-${local.aws_account_id}-${var.indexing_stack_region}"
    key    = "${var.indexing_stack_region}/${local.env}/stacks/indexing/terraform.tfstate"
    region = var.indexing_stack_region
  }
}

data "terraform_remote_state" "event" {
  backend = "s3"
  config = {
    bucket = "ipfs-ep-terraform-state-${local.aws_account_id}-${var.event_stack_region}"
    key    = "${var.event_stack_region}/${local.env}/stacks/event/terraform.tfstate"
    region = var.event_stack_region
  }
}

# TODO: Rename to 'lambda'. Migrate state
module "lambda_from_sns" {
  source                 = "../../modules/lambda"
  sns_topic_trigger_arns = formatlist("arn:aws:sns:${local.region}:${local.aws_account_id}:%s", var.sns_topic_trigger_names)
  region                 = local.region
  lambda = {
    image_uri             = local.bucket_to_indexer_image_url
    name                  = var.lambda.name
    memory_size           = var.lambda.memory_size
    timeout               = var.lambda.timeout
    environment_variables = local.environment_variables
    policies_list = [
      data.terraform_remote_state.indexing.outputs.sqs_indexer_policy_send,
      data.terraform_remote_state.event.outputs.sns_event_topic_policy_send
    ]
  }
}

resource "aws_ecr_repository" "ecr_repo_bucket_to_indexer_lambda" {
  name = var.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
}
