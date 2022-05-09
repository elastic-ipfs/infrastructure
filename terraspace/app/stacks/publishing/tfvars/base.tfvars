provider_ads_bucket_name = "<%= expansion(':ENV') %>-ep-ipfs-advertisement"
content_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-publishing-content"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-publishing-content"
}
ads_lambda = {
  name              = "<%= expansion(':ENV') %>-ep-publishing-advertisement"
  metrics_namespace = "<%= expansion(':ENV') %>-ep-publishing-advertisement"
}
indexer_node_url                                = "https://staging.cid.contact"
node_env                                        = "<%= expansion(':ENV') %>"
ecr_repository_name                             ="<%= expansion(':ENV') %>-ep-publisher-lambda"
// TODO: Read from DNS when DNS stack exists (instead of hardcoded string) output('dns.bitswap_loadbalancer_domain', mock: "")
dns_stack_bitswap_loadbalancer_domain           = "peer.ipfs-elastic-provider-aws.com"
// **
shared_stack_s3_config_peer_bucket_policy_read  = <%= output('shared.s3_config_peer_bucket_policy_read', mock: "") %>
shared_stack_sqs_multihashes_policy_receive     = <%= output('shared.sqs_multihashes_policy_receive', mock: "") %>
shared_stack_sqs_multihashes_policy_delete      = <%= output('shared.sqs_multihashes_policy_delete', mock: "") %>
shared_stack_ipfs_peer_bitswap_config_bucket_id = "<%= output('shared.ipfs_peer_bitswap_config_bucket', mock: '').to_ruby['id'] %>"
shared_stack_sqs_multihashes_topic_arn          = "<%= output('shared.sqs_multihashes_topic', mock: '').to_ruby['arn'] %>"
publishing_lambda_image_version                 = "latest"
