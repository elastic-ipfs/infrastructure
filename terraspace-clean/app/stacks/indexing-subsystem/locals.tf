locals {
  indexer_lambda = {
    name = "indexer"
  }

  environment_variables = {
    "CONCURRENCY"                 = "32"
    "NODE_ENV"                    = "production"
    "SKIP_PUBLISHING"             = "false"
    "SQS_PUBLISHING_QUEUE_URL"    = data.terraform_remote_state.shared.outputs.sqs_multihashes_topic.url
    "SQS_NOTIFICATIONS_QUEUE_URL" = aws_sqs_queue.notifications_topic.url
  }

  indexer_image_url = "505595374361.dkr.ecr.us-west-2.amazonaws.com/indexer-lambda:latest"
}
