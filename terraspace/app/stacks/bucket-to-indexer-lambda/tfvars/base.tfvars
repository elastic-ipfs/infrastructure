lambda = {
  name        = "<%= expansion(':ENV') %>-ep-bucket-to-indexer"
  memory_size = 1024
  timeout     = 900
}


node_env                               = "<%= expansion(':ENV') %>"
indexing_stack_region                  = "us-west-2"
ecr_repository_name                    = "<%= expansion(':ENV') %>-ep-bucket-to-indexer-lambda"
bucket_to_indexer_lambda_image_version = "latest"
event_stack_sns_topic_policy_send      = <%= output('event.sns_event_topic_policy_send', mock: {}) %>
