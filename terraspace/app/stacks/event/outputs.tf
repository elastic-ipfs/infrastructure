output "sns_event_topic_policy_send" {
  value = {
    name = aws_iam_policy.sns_event_topic_send.name,
    arn  = aws_iam_policy.sns_event_topic_send.arn,
  }
  description = "Policy for sending messages to SNS event topic"
}

output "sns_event_topic_arn" {
  value       = aws_sns_topic.event_topic.arn
  description = "SNS event topic"
}
