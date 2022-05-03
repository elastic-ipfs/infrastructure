output "sqs_indexer_topic" {
  value = {
    url = aws_sqs_queue.indexer_topic.url
    arn = aws_sqs_queue.indexer_topic.arn
  }
  description = "This queue is supposed to be used for triggering indexer lambda"
}

output "sqs_notifications_policy_receive" {
  value = {
    name = aws_iam_policy.sqs_notifications_policy_receive.name,
    arn  = aws_iam_policy.sqs_notifications_policy_receive.arn,
  }
  description = "Policy for allowing receive messages from notifications sqs queue"
}

output "sqs_notifications_policy_delete" {
  value = {
    name = aws_iam_policy.sqs_notifications_policy_delete.name,
    arn  = aws_iam_policy.sqs_notifications_policy_delete.arn,
  }
  description = "Policy for allowing delete messages from notifications sqs queue"
}

output "sqs_indexer_policy_send" {
  value = {
    name = aws_iam_policy.sqs_indexer_policy_send.name,
    arn  = aws_iam_policy.sqs_indexer_policy_send.arn,
  }
  description = "Policy for allowing send messages to indexer sqs queue"
}
