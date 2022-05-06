provider_ads_bucket_name = "ipfs-advertisement"
ads_topic_name="advertisements-topic"
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
indexer_node_url="https://cid.contact"
node_env="production"