variable "account_id" {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "indexer_topic_name" {
  type = string
}

variable "notifications_topic_name" {
  type = string
}

variable "indexer_lambda" {
  type = object({
    name              = string
    metrics_namespace = string
  })
}

variable "node_env" {
  type = string
}

variable "sqs_indexer_policy_receive_name" {
  type = string
}

variable "sqs_indexer_policy_delete_name" {
  type = string
}

variable "sqs_notifications_policy_receive_name" {
  type = string
}

variable "sqs_notifications_policy_delete_name" {
  type = string
}

variable "sqs_notifications_policy_send_name" {
  type = string
}

variable "sqs_indexer_policy_send_name" {
  type = string
}

variable "shared_stack_sqs_multihashes_topic" {
  type = object({
    url = string
    arn = string
  })
}

variable "shared_stack_dynamodb_blocks_policy" {
  type = object({
    name = string
    arn  = string
  })
}

variable "shared_stack_dynamodb_car_policy" {
  type = object({
    name = string
    arn  = string
  })
}

variable "shared_stack_sqs_multihashes_policy_send" {
  type = object({
    name = string
    arn  = string
  })
}

variable "shared_stack_s3_dotstorage_prod_0_policy_read" {
  type = object({
    name = string
    arn  = string
  })
}
