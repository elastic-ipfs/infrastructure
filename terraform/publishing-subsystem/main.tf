terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.publishing.tfstate"
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

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.shared.tfstate"
    region = var.region
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Environment = "POC"
      Subsystem   = "Publishing"
      ManagedBy   = "Terraform"
    }
  }
}


module "content_lambda_from_sqs" {
  source = "../modules/lambda-from-sqs"
  sqs_trigger = {
    arn                                = data.terraform_remote_state.shared.outputs.sqs_multihashes_topic.arn
    batch_size                         = 10000
    maximum_batching_window_in_seconds = 30
  }

  lambda = {
    image_uri                      = local.publisher_image_url
    name                           = "${local.content_lambda.name}-test-module" # TODO: Remove '-test-module' sufix
    memory_size                    = 1024
    timeout                        = 60
    reserved_concurrent_executions = -1 # No restrictions
    environment_variables = merge(
      local.environment_variables,
      {
        HANDLER = "content"
      }
    )

    policies_list = [
      data.terraform_remote_state.shared.outputs.s3_config_peer_bucket_policy_read,
      data.terraform_remote_state.shared.outputs.sqs_multihashes_policy_receive,
      data.terraform_remote_state.shared.outputs.sqs_multihashes_policy_delete,
      aws_iam_policy.s3_ads_policy_read,
      aws_iam_policy.s3_ads_policy_write,
      aws_iam_policy.sqs_ads_policy_send,
    ]
  }

}

module "ads_lambda_from_sqs" {
  source = "../modules/lambda-from-sqs"

  sqs_trigger = {
    arn                                = aws_sqs_queue.ads_topic.arn
    batch_size                         = 100
    maximum_batching_window_in_seconds = 5
  }

  lambda = {
    image_uri                      = local.publisher_image_url
    name                           = "${local.ads_lambda.name}-test-module" # TODO: Remove '-test-module' sufix
    memory_size                    = 1024
    timeout                        = 300
    reserved_concurrent_executions = 1
    environment_variables = merge(
      local.environment_variables,
      {
        HANDLER = "advertisement"
      }
    )

    policies_list = [
      data.terraform_remote_state.shared.outputs.s3_config_peer_bucket_policy_read,
      aws_iam_policy.s3_ads_policy_write,
      aws_iam_policy.s3_ads_policy_read,
      aws_iam_policy.sqs_ads_policy_receive,
      aws_iam_policy.sqs_ads_policy_delete,
    ]
  }
}


resource "aws_lambda_event_source_mapping" "multihashes_event_triggers_content" {
  event_source_arn                   = data.terraform_remote_state.shared.outputs.sqs_multihashes_topic.arn
  enabled                            = true
  function_name                      = aws_lambda_function.content.arn
  batch_size                         = 10000
  maximum_batching_window_in_seconds = 30
}

resource "aws_lambda_function" "content" {
  function_name = local.content_lambda.name
  package_type  = "Image"
  image_uri     = local.publisher_image_url
  role          = aws_iam_role.content_lambda_role.arn
  memory_size   = 1024
  timeout       = 60

  environment {
    variables = {
      BITSWAP_PEER_MULTIADDR       = "/dns4/a041218039f304a65a3ea818796ec078-530051802.us-west-2.elb.amazonaws.com/tcp/3000/ws"
      HANDLER                      = "content"
      INDEXER_NODE_URL             = "http://54.244.99.27:3001"
      NODE_ENV                     = "production"
      PEER_ID_FILE                 = "peerId.json"
      PEER_ID_S3_BUCKET            = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
      S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
      SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.content_lambda_logs,
    aws_cloudwatch_log_group.content_log_group,
  ]
}

resource "aws_sqs_queue" "ads_topic" {
  name                       = "advertisements-topic"
  message_retention_seconds  = 900 # 15 min
  visibility_timeout_seconds = 300 # 5 min
}

resource "aws_lambda_event_source_mapping" "ads_event_triggers_ads" {
  event_source_arn                   = aws_sqs_queue.ads_topic.arn
  enabled                            = true
  function_name                      = aws_lambda_function.ads.arn
  batch_size                         = 100
  maximum_batching_window_in_seconds = 5
}

resource "aws_lambda_function" "ads" {
  function_name                  = local.ads_lambda.name
  image_uri                      = local.publisher_image_url
  package_type                   = "Image"
  role                           = aws_iam_role.ads_lambda_role.arn
  memory_size                    = 1024
  timeout                        = 300
  reserved_concurrent_executions = 1 # https://docs.aws.amazon.com/lambda/latest/operatorguide/reserved-concurrency.html

  environment {
    variables = {
      BITSWAP_PEER_MULTIADDR       = "/dns4/a041218039f304a65a3ea818796ec078-530051802.us-west-2.elb.amazonaws.com/tcp/3000/ws"
      HANDLER                      = "advertisement"
      INDEXER_NODE_URL             = "http://54.244.99.27:3001"
      NODE_ENV                     = "production"
      PEER_ID_FILE                 = "peerId.json"
      PEER_ID_S3_BUCKET            = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
      S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
      SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.ads_lambda_logs,
    aws_cloudwatch_log_group.ads_log_group,
  ]
}

resource "aws_s3_bucket" "ipfs_peer_ads" {
  bucket = var.provider_ads_bucket_name
  acl    = "public-read" # Must be public read so PL IPFS components are capable of reading
}
