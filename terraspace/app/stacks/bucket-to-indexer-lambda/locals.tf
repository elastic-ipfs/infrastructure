locals {
  bucket_to_indexer_image_url = "${aws_ecr_repository.ecr_repo_bucket_to_indexer_lambda.repository_url}:${var.bucket_to_indexer_lambda_image_version}"
}
