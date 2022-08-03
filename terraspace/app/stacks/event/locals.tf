locals {
  environment_variables = {
    "NODE_ENV"                             = var.node_env
    "EVENT_TARGET"                         = var.event_target
    "EVENT_TARGET_CREDENTIALS_SECRET_NAME" = var.event_target_credentials_secret.name
  }
  event_delivery_image_url = "${aws_ecr_repository.ecr_repo_event_delivery_lambda.repository_url}:${var.event_delivery_image_version}"
}
