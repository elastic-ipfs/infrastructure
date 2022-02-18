locals {
  content_lambda = {
    name = "publishing-content"
  }
  ads_lambda = {
    name = "publishing-advertisement"
  }

  environment_variables = {
    BITSWAP_PEER_MULTIADDR       = "/dns4/afb33e07892214fd0ad11b52ddd30fb0-614313715.us-west-2.elb.amazonaws.com/tcp/3000/ws"
    INDEXER_NODE_URL             = "http://abcca6d4490f0426d9dd855139563762-159596440.us-east-2.elb.amazonaws.com:3001"
    NODE_ENV                     = "production"
    PEER_ID_FILE                 = "peerId.json"
    PEER_ID_S3_BUCKET            = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
    S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
    SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
  }

  publisher_image_url = "505595374361.dkr.ecr.us-west-2.amazonaws.com/publisher-lambda:latest"
}
