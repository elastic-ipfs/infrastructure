locals {
  environment_variables = {
    "NODE_ENV"                 = var.node_env
    "SQS_INDEXER_QUEUE_REGION" = var.indexing_stack_region
    "SQS_INDEXER_QUEUE_URL"    = data.terraform_remote_state.indexing.outputs.sqs_indexer_topic.url
    "SNS_EVENTS_TOPIC"         = data.terraform_remote_state.event.outputs.sns_event_topic_arn
  }
  bucket_to_indexer_image_url = "${aws_ecr_repository.ecr_repo_bucket_to_indexer_lambda.repository_url}:${var.bucket_to_indexer_lambda_image_version}"
}
