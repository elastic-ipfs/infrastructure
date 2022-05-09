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
indexer_node_url    = "https://cid.contact"
node_env            = "production"
ecr_repository_name = "publisher-lambda"
