resource "aws_kms_key" "event_stack" {
  description = "Key for Elastic IPFS event stack secrets"
}

# resource "aws_kms_alias" "event_stack" {
#   name          = "alias/my-key-alias"
#   target_key_id = aws_kms_key.a.key_id
# }

resource "aws_ssm_parameter" "event_target_credentials" {
  name        = var.event_target_credentials_secret.name
  description = var.event_target_credentials_secret.description
  key_id      = aws_kms_key.event_stack.key_id
  type        = "SecureString"
  value       = "replace_me"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
