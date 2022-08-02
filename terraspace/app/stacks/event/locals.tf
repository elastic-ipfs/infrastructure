locals {
  environment_variables = {
    "NODE_ENV"     = var.node_env
    "EVENT_TARGET" = replace(var.event_target, var.event_credential_secret_placeholder, data.aws_ssm_parameter.event_target_credentials.value)
  }
  event_delivery_image_url = "${aws_ecr_repository.ecr_repo_event_delivery_lambda.repository_url}:${var.event_delivery_image_version}"
}
