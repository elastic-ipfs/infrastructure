locals {
  environment_variables = {
    BITSWAP_PEER_MULTIADDR       = "/dns4/${var.dns_stack_bitswap_loadbalancer_domain}/tcp/3000/ws"
    INDEXER_NODE_URL             = var.indexer_node_url
    NODE_ENV                     = var.node_env
    PEER_ID_FILE                 = "peerId.json"
    PEER_ID_S3_BUCKET            = var.shared_stack_ipfs_peer_bitswap_config_bucket_id
    S3_BUCKET                    = aws_s3_bucket.ipfs_peer_ads.id
    SQS_ADVERTISEMENTS_QUEUE_URL = aws_sqs_queue.ads_topic.url
    SNS_EVENTS_TOPIC             = var.event_stack_sns_events_topic_arn
  }
  publisher_image_url = "${aws_ecr_repository.ecr_repo_publisher_lambda.repository_url}:${var.publishing_lambda_image_version}"
}
