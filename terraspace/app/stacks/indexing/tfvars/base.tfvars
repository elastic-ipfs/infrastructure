# This follows current namespacing pattern: https://filecoinproject.slack.com/archives/C02BZPRS9HP/p1650986348274689?thread_ts=1646828696.183769&cid=C02BZPRS9HP
account_id               = "<%= expansion(':ACCOUNT') %>"
ecr_repository_name      = "<%= expansion(':ENV') %>-ep-indexer-lambda"
indexer_topic_name       = "<%= expansion(':ENV') %>-ep-indexer-topic"
notifications_topic_name = "<%= expansion(':ENV') %>-ep-notifications-topic"
indexer_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-indexer"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-indexer-lambda-metrics"
}
node_env                              = "<%= expansion(':ENV') %>"
sqs_indexer_policy_receive_name       = "<%= expansion(':ENV') %>-ep-sqs-indexer-receive"
sqs_indexer_policy_delete_name        = "<%= expansion(':ENV') %>-ep-sqs-indexer-delete"
sqs_notifications_policy_receive_name = "<%= expansion(':ENV') %>-ep-sqs-notifications-receive"
sqs_notifications_policy_delete_name  = "<%= expansion(':ENV') %>-ep-sqs-notifications-delete"
sqs_notifications_policy_send_name    = "<%= expansion(':ENV') %>-ep-sqs-notifications-send"
sqs_indexer_policy_send_name          = "<%= expansion(':ENV') %>-ep-sqs-indexer-send"
