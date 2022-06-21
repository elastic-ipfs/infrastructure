variable "sns_topic" {
  type = string
  description = "Name of SNS topic which lambda should subscribe to"
}

variable "lambda" {
  type = object({
    name        = string
    memory_size = string
    timeout     = string
  })
  description = "bucket_to_indexer lambda attributes"
}

variable "node_env" {
  type        = string
  description = "NODE_ENV environment variable value for bucket_to_indexer lambda"
}

variable "indexing_stack_region" {
  type        = string
  description = "Region which indexer is deployed to"
}

variable "ecr_repository_name" {
  type        = string
  description = "Name for ECR repo. We use this repo to store bucket-to-indexer lambda docker image"
}

variable "bucket_to_indexer_lambda_image_version" {
  type        = string
  default     = "latest"
  description = "Version tag for bucket_to_indexer lambda"
}
