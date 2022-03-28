locals {
  content_lambda = {
    name = "publishing-content"
  }
  ads_lambda = {
    name = "publishing-advertisement"
  }

  environment_variables = {
    BITSWAP_PEER_MULTIADDR       = "/dns4/afb33e07892214fd0ad11b52ddd30fb0-614313715.us-west-2.elb.amazonaws.com/tcp/3000/ws"
    INDEXER_NODE_URL             = "http://ae12982c68cbd4f0d8b07163518cd1ee-1196334068.us-east-1.elb.amazonaws.com:3001"
    NODE_ENV                     = "production"
    PEER_ID_FILE                 = "peerId.json"
    PEER_ID_S3_BUCKET            = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
    S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
    SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
  }

  publisher_image_url = "505595374361.dkr.ecr.us-west-2.amazonaws.com/publisher-lambda:latest"
}
