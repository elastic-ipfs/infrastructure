ecr_repository_name           = "<%= expansion(':ENV') %>-ep-event-delivery-lambda"
event_delivery_image_version  = "latest"
sns_event_topic_name          = "<%= expansion(':ENV') %>-ep-event-topic"
sqs_event_delivery_queue_name = "<%= expansion(':ENV') %>-ep-event-delivery-queue"
event_delivery_lambda         = {
  name              = "<%= expansion(':ENV') %>-ep-event-delivery"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-event-delivery-lambda-metrics"
}
sqs_event_delivery_queue_policy_receive_name = "<%= expansion(':ENV') %>-ep-sqs-event-delivery-receive"
sns_event_topic_policy_send_name             = "<%= expansion(':ENV') %>-ep-sns-event-send"
sqs_event_delivery_queue_policy_send_name    = "<%= expansion(':ENV') %>-ep-sqs-event-delivery-send"
node_env                                     = "<%= expansion(':ENV') %>"
batch_size                                   = 1
event_target_credentials_secret =  {
  name        = "/<%= expansion(':ENV') %>/ep/<%= expansion(':MOD_NAME') %>/event_target_credentials"
  description = "Event Target Credentials"
}
secrets_key = {
  name        = "<%= expansion(':ENV') %>-ep-<%= expansion(':MOD_NAME') %>"
  description = "Key for Elastic IPFS <%= expansion(':MOD_NAME') %> stack secrets in <%= expansion(':ENV') %> environment"
}
read_event_target_credentials_param_policy_name = "<%= expansion(':ENV') %>-ep-param-store-event-target-credentials-read"
