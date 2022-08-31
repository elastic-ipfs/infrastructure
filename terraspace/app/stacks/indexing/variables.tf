variable "ecr_repository_name" {
  type        = string
  description = "Name for ECR repo. We use this repo to store indexer lambda docker image"
}

variable "indexer_topic_name" {
  type        = string
  description = "Name for indexer sqs queue. This is queue is supposed to be read by indexer lambda"
}

variable "indexer_lambda" {
  type = object({
    name              = string
    metrics_namespace = string
  })
  description = "Indexer lambda is the core component of the indexing stack"
}

variable "node_env" {
  type        = string
  description = "NODE_ENV environment variable value for indexer lambda"
}

variable "dynamodb_blocks_table" {
  type        = string
  description = "DYNAMO_BLOCKS_TABLE environment variable value for indexer lambda"
}

variable "dynamodb_cars_table" {
  type        = string
  description = "DYNAMO_CARS_TABLE environment variable value for indexer lambda"
}

variable "dynamodb_link_table" {
  type        = string
  description = "DYNAMO_LINK_TABLE environment variable value for indexer lambda"
}

variable "batch_size" {
  type        = string
  description = "Amount of messages indexer lambda should batch to handle simultaneously"
}

variable "concurrency" {
  type        = string
  description = "Amount of blocks indexer lambda should handle simultaneously"
}

variable "sqs_indexer_policy_receive_name" {
  type        = string
  description = "Name for policy which allows receiving messages from indexer sqs queue"
}

variable "sqs_indexer_policy_send_name" {
  type        = string
  description = "Name for policy which allows sending messages to indexer sqs queue"
}

variable "event_stack_sns_events_topic_arn" {
  type        = string
  description = "SNS event topic"
}

variable "shared_stack_sqs_multihashes_topic_url" {
  type        = string
  description = "This queue is managed by the shared stack. Indexer lambda sends messages to it"
}

variable "shared_stack_dynamodb_blocks_policy" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table"
}

variable "shared_stack_dynamodb_car_policy" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table"
}

variable "shared_stack_dynamodb_link_policy" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table"
}

variable "shared_stack_sqs_multihashes_policy_send" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for sending messages to multihashes sqs queue"

}

variable "shared_stack_s3_dotstorage_policy_read" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for reading external bucket 'dotstorage_prod_0' objects content"
}

variable "shared_stack_decrypt_key_policy" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the event stack. Lambda requires policy for decrypting data from dynamodb tables"
}

variable "event_stack_sns_topic_policy_send" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the event stack. Lambda requires policy for sending events through pub/sub messaging"
}

variable "indexing_lambda_image_version" {
  type        = string
  default     = "latest"
  description = "Version tag for publishing lambda"
}

variable "dynamodb_max_retries" {
  type        = string
  description = "DYNAMO_MAX_RETRIES environment variable value for indexer lambda"
}

variable "dynamodb_retry_delay" {
  type        = string
  description = "DYNAMO_RETRY_DELAY environment variable value for indexer lambda"
}

variable "s3_max_retries" {
  type        = string
  description = "S3_MAX_RETRIES environment variable value for indexer lambda"
}

variable "s3_retry_delay" {
  type        = string
  description = "S3_RETRY_DELAY environment variable value for indexer lambda"
}
