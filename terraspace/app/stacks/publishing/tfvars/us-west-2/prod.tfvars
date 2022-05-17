provider_ads_bucket_name = "ipfs-advertisement"
ads_topic_name           = "advertisements-topic"
content_lambda = {
  name              = "publishing-content"
  metrics_namespace = "publishing-lambda-metrics"
}
ads_lambda = {
  name              = "publishing-advertisement"
  metrics_namespace = "publishing-lambda-metrics"
}
indexer_node_url            = "https://cid.contact"
node_env                    = "production"
ecr_repository_name         = "publisher-lambda"
s3_ads_policy_write_name    = "s3-ads-policy-write"
s3_ads_policy_read_name     = "s3-ads-policy-read"
sqs_ads_policy_send_name    = "sqs-ads-policy-send"
sqs_ads_policy_receive_name = "sqs-ads-policy-receive"
sqs_ads_policy_delete_name  = "sqs-ads-policy-delete"
