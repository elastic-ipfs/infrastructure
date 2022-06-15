node_env = "production"
lambda = {
  name        = "bucket-to-indexer"
  memory_size = 1024
  timeout     = 900
}
bucket = (
  {
    bucket = "dotstorage-prod-0"
    arn    = "arn:aws:s3:::dotstorage-prod-0"
    id     = "dotstorage-prod-0"
  }
)
ecr_repository_name = "bucket-to-indexer-lambda"
