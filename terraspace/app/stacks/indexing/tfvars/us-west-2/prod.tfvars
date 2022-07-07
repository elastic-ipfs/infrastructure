# Prod does not follow base.tfvars patterns for keeping compatibility with pre-existing components
ecr_repository_name      = "indexer-lambda"
indexer_topic_name       = "indexer-topic"
notifications_topic_name = "notifications-topic"
indexer_lambda = {
  name              = "indexer"
  metrics_namespace = "indexer-lambda-metrics"
}
node_env                              = "production"
sqs_indexer_policy_receive_name       = "sqs-indexer-receive"
sqs_indexer_policy_delete_name        = "sqs-indexer-delete"
sqs_notifications_policy_receive_name = "sqs-notifications-receive"
sqs_notifications_policy_delete_name  = "sqs-notifications-delete"
sqs_notifications_policy_send_name    = "sqs-notifications-send"
sqs_indexer_policy_send_name          = "sqs-indexer-send"
