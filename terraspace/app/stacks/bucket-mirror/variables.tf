variable "subnet_id" {
  type        = string
  description = "ID of subnet where bucket-mirror should run"
}

variable "security_group_id" {
  type        = string
  description = "ID of security group where bucket-mirror should run"
}

variable "key_name" {
  type        = string
  description = "AWS key Pair name"
}

variable "ec2_instance_name" {
  type        = string
  description = "Name for the EC2 which will run bucket mirror"
}

variable "bucket_mirror_ami_name" {
  type        = string
  description = "Name of image (AMI) which contains 'bucket-mirror' prepared to run"
}

variable "source_bucket_name" {
  type        = string
  description = "Name of bucket to read objects from"
}

variable "s3_client_aws_region" {
  type        = string
  description = "Which region is the source bucket"
}

variable "s3_prefix" {
  type        = string
  description = "Only read objects with this prefix"
  default     = ""
}

variable "s3_suffix" {
  type        = string
  description = "Only read objects with this suffix"
}

variable "sqs_queue_url" {
  type        = string
  description = "indexer SQS queue URL"
}

variable "read_only_mode" {
  type        = string
  description = "Should be 'disable' for sending messages to SQS queue. Otherwise it will just read existing files from bucket"
  default     = "enabled"
}

variable "file_await" {
  type        = number
  description = "How long to await between files. Useful for avoiding DB throttling"
  default     = 0
}

variable "next_page_await" {
  type        = number
  description = "How long to await after fetching 1000 files. Useful for avoiding DB throttling"
  default     = 0
}

variable "policies_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "List of policies which are going to be attached to EC2 role"
}

variable "node_env" {
  type        = string
  description = "node_env environment variable value. Has effect on logs"
  default     = "production"
}

variable "log_level" {
  type        = string
  description = "which level of logs should be outputted"
  default     = "info"
}

variable "log_after_value_files" {
  type        = number
  description = "define after how many files to update run status in log"
}
