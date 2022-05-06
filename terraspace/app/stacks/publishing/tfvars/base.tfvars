provider_ads_bucket_name = "ipfs-advertisement"
content_lambda = {
  name              = "publishing-content"
  metrics_namespace = "publishing-lambda-metrics"
  image_uri         = "505595374361.dkr.ecr.us-west-2.amazonaws.com/publisher-lambda:latest"
}
ads_lambda = {
  name              = "publishing-advertisement"
  metrics_namespace = "publishing-lambda-metrics"
  image_uri         = "505595374361.dkr.ecr.us-west-2.amazonaws.com/publisher-lambda:latest"
}
indexer_node_url="https://staging.cid.contact"

dns_stack_bitswap_loadbalancer_domain=<%= output('dns.bitswap_loadbalancer_domain', mock: "") %>
shared_stack_s3_config_peer_bucket_policy_read=<%= output('shared.s3_config_peer_bucket_policy_read', mock: "") %>
shared_stack_sqs_multihashes_policy_receive=<%= output('shared.sqs_multihashes_policy_receive', mock: "") %>
shared_stack_sqs_multihashes_policy_delete=<%= output('shared.sqs_multihashes_policy_delete', mock: "") %>
shared_stack_ipfs_peer_bitswap_config_bucket_id="<%= output('shared.ipfs_peer_bitswap_config_bucket', mock: '').to_ruby['id'] %>"
// TODO: ECR REPO?