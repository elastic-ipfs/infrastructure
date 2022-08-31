output "dynamodb_v1_blocks_table_name" {
  value       = aws_dynamodb_table.v1_blocks_table.name
  description = "v1 blocks table name"
}

output "dynamodb_v1_cars_table_name" {
  value       = aws_dynamodb_table.v1_cars_table.name
  description = "v1 cars table name"
}

output "dynamodb_v1_link_table_name" {
  value       = aws_dynamodb_table.v1_link_table.name
  description = "v1 link table name"
}

output "ipfs_peer_bitswap_config_bucket" {
  value = {
    bucket = aws_s3_bucket.ipfs_peer_bitswap_config.bucket
    id     = aws_s3_bucket.ipfs_peer_bitswap_config.id
    arn    = aws_s3_bucket.ipfs_peer_bitswap_config.arn
    region = aws_s3_bucket.ipfs_peer_bitswap_config.region
  }
  description = "The bucket which contains configurations that some elastic provider apps require"
}

output "sqs_multihashes_topic" {
  value = {
    url = aws_sqs_queue.multihashes_topic.url,
    arn = aws_sqs_queue.multihashes_topic.arn,
  }
  description = "This queue is supposed to be used for triggering publisher lambda (content)"
}

output "dynamodb_blocks_policy" {
  value = {
    name = module.dynamodb.dynamodb_blocks_policy.name,
    arn  = module.dynamodb.dynamodb_blocks_policy.arn,
  }
  description = "Policy for allowing all Dynamodb Actions for blocks table"
}

output "dynamodb_car_policy" {
  value = {
    name = module.dynamodb.dynamodb_car_policy.name,
    arn  = module.dynamodb.dynamodb_car_policy.arn,
  }
  description = "Policy for allowing all Dynamodb Actions for cars table"
}

output "dynamodb_v1_blocks_policy" {
  value = {
    name = aws_iam_policy.dynamodb_v1_blocks_policy.name
    arn  = aws_iam_policy.dynamodb_v1_blocks_policy.arn
  }
  description = "Policy for allowing all Dynamodb Actions for V1 blocks table"
}

output "dynamodb_v1_cars_policy" {
  value = {
    name = aws_iam_policy.dynamodb_v1_cars_policy.name
    arn  = aws_iam_policy.dynamodb_v1_cars_policy.arn
  }
  description = "Policy for allowing all Dynamodb Actions for V1 cars table"
}

output "dynamodb_v1_link_policy" {
  value = {
    name = aws_iam_policy.dynamodb_v1_link_policy.name
    arn  = aws_iam_policy.dynamodb_v1_link_policy.arn
  }
  description = "Policy for allowing all Dynamodb Actions for V1 links table"
}

output "s3_config_peer_bucket_policy_read" {
  value = {
    name = aws_iam_policy.s3_config_peer_bucket_policy_read.name,
    arn  = aws_iam_policy.s3_config_peer_bucket_policy_read.arn,
  }
  description = "Policy for allowing read files from configuration bucket"
}

output "sqs_multihashes_policy_send" {
  value = {
    name = aws_iam_policy.sqs_multihashes_policy_send.name,
    arn  = aws_iam_policy.sqs_multihashes_policy_send.arn,
  }
  description = "Policy for allowing send messages to multihashes sqs queue"
}

output "sqs_multihashes_policy_receive" {
  value = {
    name = aws_iam_policy.sqs_multihashes_policy_receive.name,
    arn  = aws_iam_policy.sqs_multihashes_policy_receive.arn,
  }
  description = "Policy for allowing receive messages from multihashes sqs queue"
}


output "sqs_multihashes_policy_delete" {
  value = {
    name = aws_iam_policy.sqs_multihashes_policy_delete.name,
    arn  = aws_iam_policy.sqs_multihashes_policy_delete.arn,
  }
  description = "Policy for allowing delete messages from multihashes sqs queue"
}

output "s3_dotstorage_policy_read" {
  value = {
    name = aws_iam_policy.s3_dotstorage_policy_read.name,
    arn  = aws_iam_policy.s3_dotstorage_policy_read.arn,
  }
  description = "Policy for allowing reading files from existing bucket called 'dotstorage_prod_0'"
}

output "decrypt_key_policy" {
  value = {
    name = aws_iam_policy.decrypt_shared_stack_key.name,
    arn  = aws_iam_policy.decrypt_shared_stack_key.arn,
  }
  description = "Policy which allows decrypting shared stack key'"
}
