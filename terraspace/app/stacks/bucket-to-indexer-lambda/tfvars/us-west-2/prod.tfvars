node_env = "production"
lambda = {
  name        = "bucket-to-indexer"
  memory_size = 1024
  timeout     = 900
}
ecr_repository_name = "bucket-to-indexer-lambda"
sns_topic_triggers  = ["ep-s3-put"]
