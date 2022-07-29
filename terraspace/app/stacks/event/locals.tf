locals {
  environment_variables = {
    "NODE_ENV"     = var.node_env
    "EVENT_TARGET" = var.event_target
  }

  event_delivery_image_url = "${aws_ecr_repository.ecr_repo_event_delivery_lambda.repository_url}:${var.event_delivery_image_version}"
}
