# This follows current namespacing pattern: https://filecoinproject.slack.com/archives/C02BZPRS9HP/p1650986348274689?thread_ts=1646828696.183769&cid=C02BZPRS9HP
account_id               = "<%= expansion(':ACCOUNT') %>"
ecr_repository_name      = "<%= expansion(':ENV') %>-ep-indexer-lambda"
indexer_topic_name       = "<%= expansion(':ENV') %>-ep-indexer-topic"
indexer_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-indexer"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-indexer-lambda-metrics"
}
batch_size                                    = 1
concurrency                                   = 64
node_env                                      = "<%= expansion(':ENV') %>"
sqs_indexer_policy_receive_name               = "<%= expansion(':ENV') %>-ep-sqs-indexer-receive"
sqs_indexer_policy_send_name                  = "<%= expansion(':ENV') %>-ep-sqs-indexer-send"
shared_stack_sqs_multihashes_topic_url        = "<%= output('shared.sqs_multihashes_topic', mock: {}).to_ruby['url'] %>"
shared_stack_dynamodb_blocks_policy           = <%= output('shared.dynamodb_v1_blocks_policy', mock: {}) %>
shared_stack_dynamodb_car_policy              = <%= output('shared.dynamodb_v1_cars_policy', mock: {}) %>
shared_stack_dynamodb_link_policy             = <%= output('shared.dynamodb_v1_link_policy', mock: {}) %>
shared_stack_sqs_multihashes_policy_send      = <%= output('shared.sqs_multihashes_policy_send', mock: {}) %>
shared_stack_s3_dotstorage_policy_read        = <%= output('shared.s3_dotstorage_policy_read', mock: {}) %>
event_stack_sns_events_topic_arn              = <%= output('event.sns_event_topic_arn', mock: '') %>
event_stack_sns_topic_policy_send             = <%= output('event.sns_event_topic_policy_send', mock: {}) %>
shared_stack_decrypt_key_policy               = <%= output('shared.decrypt_key_policy', mock: {}) %>
indexing_lambda_image_version                 = "latest"
dynamodb_blocks_table                         = <%= output('shared.dynamodb_v1_blocks_table_name', mock: {}) %>
dynamodb_cars_table                           = <%= output('shared.dynamodb_v1_cars_table_name', mock: {}) %>
dynamodb_link_table                           = <%= output('shared.dynamodb_v1_link_table_name', mock: {}) %>
dynamodb_max_retries                          = 3
dynamodb_retry_delay                          = 100
s3_max_retries                                = 3
s3_retry_delay                                = 100
