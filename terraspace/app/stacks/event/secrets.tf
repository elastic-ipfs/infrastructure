resource "aws_kms_key" "event_stack" {
  description = var.secrets_key.description
}

resource "aws_kms_alias" "event_stack" {
  name          = "alias/${var.secrets_key.name}"
  target_key_id = aws_kms_key.event_stack.key_id
}

resource "aws_ssm_parameter" "event_target_credentials" {
  name        = var.event_target_credentials_secret.name
  description = var.event_target_credentials_secret.description
  key_id      = aws_kms_alias.event_stack.name
  type        = "SecureString"
  value       = "replace_me"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
