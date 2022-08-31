variable "config_bucket_name" {
  type        = string
  description = "Name for configuration bucket. This bucket is supposed to contain configurations that some elastic provider apps require"
}

variable "multihashes_topic_name" {
  type        = string
  description = "Name for multihashes sqs queue. This queue is supposed to be read by publisher lambda (content)"
}

### Deprecated (v0 tables)
variable "cars_table_name" {
  type        = string
  description = "Name for cars dynamodb table. This table is supposed to contain references to the CAR file and to control indexing status"
}

variable "blocks_table_name" {
  type        = string
  description = "Name for blocs dynamodb table. This table is supposed to contain the indexes of blocks"
}
###

variable "v1_cars_table" {
  type = object({
    name     = string
    hash_key = string
  })
  description = "v1 cars dynamodb table. This table is supposed to contain references to the CAR file"
}

variable "v1_blocks_table" {
  type = object({
    name     = string
    hash_key = string
  })
  description = "v1 blocks dynamodb table. This table is supposed to contain the indexes of blocks"
}

variable "v1_link_table" {
  type = object({
    name      = string
    hash_key  = string
    range_key = string
  })
  description = "v1 cars link table. This table is supposed to link blocks with CARs"
}

variable "multihashes_send_policy_name" {
  type        = string
  description = "Name for policy which allows sending messages to multihashes sqs queue"
}

variable "multihashes_receive_policy_name" {
  type        = string
  description = "Name for policy which allows receiving messages from multihashes sqs queue"
}

variable "multihashes_delete_policy_name" {
  type        = string
  description = "Name for policy which allows deleting messages from multihashes sqs queue"
}

variable "config_bucket_read_policy_name" {
  type        = string
  description = "Name for policy which allows reading action for configuration bucket"
}

variable "dotstorage_bucket_name" {
  type        = string
  description = "Name of existing 'dotstorage' bucket in 'us-east-2' region"
}

variable "dotstorage_bucket_1_name" {
  type        = string
  description = "Name of existing 'dotstorage' bucket in 'us-west-2' region"
}

variable "dotstorage_bucket_read_policy_name" {
  type        = string
  description = "Name for policy which allows reading messages from existing 'dotstorage' bucket "
}

variable "shared_stack_key" {
  type = object({
    name        = string,
    description = string,
  })
  description = "KMS key for this stack"
}
