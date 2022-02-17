locals {
  content_lambda = {
    name = "publishing-content"
  }
  ads_lambda = {
    name = "publishing-advertisement"
  }

  environment_variables = {
    BITSWAP_PEER_MULTIADDR       = "/dns4/a041218039f304a65a3ea818796ec078-530051802.us-west-2.elb.amazonaws.com/tcp/3000/ws"
    INDEXER_NODE_URL             = "http://54.244.99.27:3001"
    NODE_ENV                     = "production"
    PEER_ID_FILE                 = "peerId.json"
    PEER_ID_S3_BUCKET            = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
    S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
    SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
  }
}
