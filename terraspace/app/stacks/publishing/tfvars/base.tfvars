provider_ads_bucket_name = "<%= expansion(':ENV') %>-ep-ipfs-advertisement"
ads_topic_name           = "<%= expansion(':ENV') %>-ep-advertisements-topic"
content_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-publishing-content"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-publishing-content"
}
ads_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-publishing-advertisement"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-publishing-advertisement"
}
node_env                                        = "<%= expansion(':ENV') %>"
ecr_repository_name                             = "<%= expansion(':ENV') %>-ep-publisher-lambda"
bitswap_peer_multiaddr                          = "/dns4/<%= output('dns.bitswap_loadbalancer_domain', mock: "").to_ruby %>/tcp/443/wss"
shared_stack_s3_config_peer_bucket_policy_read  = <%= output('shared.s3_config_peer_bucket_policy_read', mock: "") %>
shared_stack_sqs_multihashes_policy_receive     = <%= output('shared.sqs_multihashes_policy_receive', mock: "") %>
shared_stack_sqs_multihashes_policy_delete      = <%= output('shared.sqs_multihashes_policy_delete', mock: "") %>
event_stack_sns_topic_policy_send               = <%= output('event.sns_event_topic_policy_send', mock: {}) %>
event_stack_sns_events_topic_arn                = <%= output('event.sns_event_topic_arn', mock: '') %>
shared_stack_ipfs_peer_bitswap_config_bucket_id = "<%= output('shared.ipfs_peer_bitswap_config_bucket', mock: '').to_ruby['id'] %>"
shared_stack_sqs_multihashes_topic_arn          = "<%= output('shared.sqs_multihashes_topic', mock: '').to_ruby['arn'] %>"
publishing_lambda_image_version                 = "latest"
s3_ads_policy_write_name                        = "<%= expansion(':ENV') %>-ep-s3-ads-policy-write"
s3_ads_policy_read_name                         = "<%= expansion(':ENV') %>-ep-s3-ads-policy-read"
sqs_ads_policy_send_name                        = "<%= expansion(':ENV') %>-ep-sqs-ads-policy-send"
sqs_ads_policy_receive_name                     = "<%= expansion(':ENV') %>-ep-sqs-ads-policy-receive"
sqs_ads_policy_delete_name                      = "<%= expansion(':ENV') %>-ep-sqs-ads-policy-delete"
