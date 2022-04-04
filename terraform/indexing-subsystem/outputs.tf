output "sqs_indexer_topic" {
  value = {
    url = aws_sqs_queue.indexer_topic.url
    arn = aws_sqs_queue.indexer_topic.arn
  }
}


output "sqs_notifications_policy_receive" {
  value = {
    name = aws_iam_policy.sqs_notifications_policy_receive.name,
    arn  = aws_iam_policy.sqs_notifications_policy_receive.arn,
  }
}


output "sqs_notifications_policy_delete" {
  value = {
    name = aws_iam_policy.sqs_notifications_policy_delete.name,
    arn  = aws_iam_policy.sqs_notifications_policy_delete.arn,
  }
}
