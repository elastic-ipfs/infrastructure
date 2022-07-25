output "sns_event_topic_policy_send" {
  value = {
    name = aws_iam_policy.sns_event_topic_send.name,
    arn  = aws_iam_policy.sns_event_topic_send.arn,
  }
  description = "Policy for sending messages to SNS event topic"
}
