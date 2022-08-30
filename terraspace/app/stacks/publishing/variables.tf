variable "provider_ads_bucket_name" {
  type        = string
  description = "Bucket for storing advertisement files"
}

variable "ads_topic_name" {
  type        = string
  description = "Name for advertisment sqs queue. This queue is supposed to have events created and pulished by content and received by publishing"
}

variable "content_lambda" {
  type = object({
    name              = string
    metrics_namespace = string
  })
  description = "Publishing (content) lambda namming"
}


variable "ads_lambda" {
  type = object({
    name              = string
    metrics_namespace = string
  })
  description = "Publishing (advertisement) lambda namming"
}

variable "publishing_lambda_image_version" {
  type        = string
  default     = "latest"
  description = "Version tag for publishing lambda"
}

variable "indexer_node_url" {
  type        = string
  description = "storetheindex HTTP API URL"
}

variable "node_env" {
  type        = string
  description = "NODE_ENV environment variable value for publishing lambdas"
}

variable "ecr_repository_name" {
  type        = string
  description = "Name for ECR repo. We use this repo to store publishing lambda docker image"
}

variable "bitswap_peer_multiaddr" {
  type = string
  description = "Bitswap peer multiaddr. This is used as value for the BITSWAP_PEER_MULTIADDR environment variable. This value is notified to storetheindex"
}

variable "shared_stack_s3_config_peer_bucket_policy_read" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared subsystem. Publishing lambdas need to read peer configuration from S3 bucket"
}

variable "shared_stack_sqs_multihashes_policy_receive" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared subsystem. Publishing lambda (content) requires policy for receiving messages from multihashes sqs queue"
}
variable "shared_stack_sqs_multihashes_policy_delete" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the shared subsystem. Publishing lambda (content) requires policy for deleting messages from multihashes sqs queue"
}

variable "shared_stack_ipfs_peer_bitswap_config_bucket_id" {
  type        = string
  description = "This bucket is managed by the shared subsystem. The bucket which contains configurations that publisher lambdas require"
}

variable "shared_stack_sqs_multihashes_topic_arn" {
  type        = string
  description = "This queue is managed by the shared subsystem. Publisher lambda (content) receives messages from this queue"
}

variable "s3_ads_policy_write_name" {
  type        = string
  description = "Name for policy which allows writting action for advertisement bucket"
}

variable "s3_ads_policy_read_name" {
  type        = string
  description = "Name for policy which allows reading action for advertisement bucket"
}

variable "sqs_ads_policy_send_name" {
  type        = string
  description = "Name for policy which allows sending messages to advertisement sqs queue"
}

variable "sqs_ads_policy_receive_name" {
  type        = string
  description = "Name for policy which allows receiving messages from advertisement sqs queue"
}

variable "sqs_ads_policy_delete_name" {
  type        = string
  description = "Name for policy which allows deleting messages from advertisement sqs queue"
}

variable "event_stack_sns_events_topic_arn" {
  type        = string
  description = "SNS event topic"
}

variable "event_stack_sns_topic_policy_send" {
  type = object({
    name = string
    arn  = string
  })
  description = "This policy is managed by the event stack. Lambda requires policy for sending events through pub/sub messaging"
}
