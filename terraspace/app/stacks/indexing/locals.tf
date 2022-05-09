locals {
  environment_variables = {
    "CONCURRENCY"                 = "32"
    "SKIP_PUBLISHING"             = "false"
    "NODE_ENV"                    = var.node_env
    "SQS_PUBLISHING_QUEUE_URL"    = var.shared_stack_sqs_multihashes_topic_url
    "SQS_NOTIFICATIONS_QUEUE_URL" = aws_sqs_queue.notifications_topic.url
  }

  indexer_image_url = "${aws_ecr_repository.ecr_repo_indexer_lambda.repository_url}:${var.indexing_lambda_image_version}"
}
