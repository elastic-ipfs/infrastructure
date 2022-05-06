variable "ecr_repository_name" {
  type        = string
  description = "Name for ECR repo. We use this repo to store indexer lambda docker image"
}

variable "indexer_topic_name" {
  type        = string
  description = "Name for indexer sqs queue. This is queue is supposed to be read by indexer lambda"
}
variable "notifications_topic_name" {
  type        = string
  description = "Name for notifications sqs queue. This is queue is supposed to have events created and published by indexer lambda. It can be read by external components"
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

variable "sqs_indexer_policy_receive_name" {
  type        = string
  description = "Name for policy which allows receiving messages from indexer sqs queue"
}

variable "sqs_indexer_policy_delete_name" {
  type        = string
  description = "Name for policy which allows deleting messages from indexer sqs queue"
}

variable "sqs_indexer_policy_send_name" {
  type        = string
  description = "Name for policy which allows sending messages to indexer sqs queue"
}

variable "sqs_notifications_policy_receive_name" {
  type        = string
  description = "Name for policy which allows receiving messages from notifications sqs queue"
}

variable "sqs_notifications_policy_delete_name" {
  type        = string
  description = "Name for policy which allows deleting messages from notifications sqs queue"
}

variable "sqs_notifications_policy_send_name" {
  type        = string
  description = "Name for policy which allows sending messages to notifications sqs queue"
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

variable "shared_stack_sqs_multihashes_policy_send" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for sending messages to multihashes sqs queue"

}

variable "shared_stack_s3_dotstorage_prod_0_policy_read" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared stack. Indexer lambda requires policy for reading external bucket 'dotstorage_prod_0' objects content"
}
