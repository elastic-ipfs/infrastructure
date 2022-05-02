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

variable "notifications_topic_name" {
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
