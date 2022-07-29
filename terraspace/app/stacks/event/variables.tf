variable "sqs_event_delivery_queue_name" {
  type        = string
  description = "Name for event delivery SQS queue. This queue is supposed to be used to trigger event-delivery-lambda"
}

variable "sns_event_topic_name" {
  type        = string
  description = "Name for event SNS topic. This topic is supposed to receive events from Elastic IPFS components"
}

variable "ecr_repository_name" {
  type        = string
  description = "Name for ECR repo. We use this repo to store event_delivery_lambda docker image"
}

variable "event_delivery_image_version" {
  type        = string
  default     = "latest"
  description = "Version tag for event lambda"
}

variable "event_delivery_lambda" {
  type = object({
    name              = string
    metrics_namespace = string
  })
  description = "Event delivery lambda is supposed to receive events and send them to external components"
}

variable "node_env" {
  type        = string
  description = "NODE_ENV environment variable value for event delivery lambda"
}

variable "sqs_event_delivery_queue_policy_receive_name" {
  type        = string
  description = "Name for policy which allows receiving messages from event delivery sqs queue"
}

variable "sns_event_topic_policy_send_name" {
  type        = string
  description = "Name for policy which allows sending messages to event sns topic"
}

variable "batch_size" {
  type        = string
  description = "Amount of messages which event delivery lambda should batch to handle simultaneously"
}

variable "event_target" {
  type        = string
  description = "EVENT_TARGET environment variable value for event delivery lambda"
}
