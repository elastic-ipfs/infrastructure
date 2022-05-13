variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "account-id" {
  type = string
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

variable "lambda_image"{
  type = string
}

variable "lambda_name" {
  type = string
  default = "bucket-to-indexer"
}

variable "lambda_memory" {
  type = number
  default = 1024
}

variable "lambda_timeout" {
  type = number
  default = 900
}

variable "node_env" {
  type        = string
  description = "NODE_ENV environment variable value for bucket-to-indexer lambda"
}

variable "indexing_stack_region" {
  type = string
  description = "Region which indexer is deployed to"
}

variable "indexing_stack_sqs_indexer_topic_url" {
  type = string
  description = "The SQS topic URL to publish message to indexing subsystem"
}

variable "indexing_stack_sqs_indexer_policy_send" {
  type        = string
  description = "Name for policy which allows sending messages to indexer sqs queue"
}
