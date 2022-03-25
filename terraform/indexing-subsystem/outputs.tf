output "sqs_indexer_topic" {
  value = {
    url = aws_sqs_queue.indexer_topic.url
    arn = aws_sqs_queue.indexer_topic.arn
  }
}
