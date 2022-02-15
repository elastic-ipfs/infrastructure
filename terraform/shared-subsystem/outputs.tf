output "cars_bucket" {
  value = {
    bucket = aws_s3_bucket.cars.bucket
    id = aws_s3_bucket.cars.id
    arn = aws_s3_bucket.cars.arn
    region = aws_s3_bucket.cars.region
  }
}

output "sqs_multihashes_topic" {
  value = {
    url = aws_sqs_queue.multihashes_topic.url
    arn = aws_sqs_queue.multihashes_topic.arn
  }
}

output "dynamodb_blocks_policy" {
  value = {
    name = module.dynamodb.dynamodb_blocks_policy.name,
    arn  = module.dynamodb.dynamodb_blocks_policy.arn,
  }
}

output "dynamodb_car_policy" {
  value = {
    name = module.dynamodb.dynamodb_car_policy.name,
    arn  = module.dynamodb.dynamodb_car_policy.arn,
  }
}

output "s3_policy_write" {
  value = {
    name = aws_iam_policy.s3_policy_write.name,
    arn  = aws_iam_policy.s3_policy_write.arn,
  }
}

output "s3_policy_read" {
  value = {
    name = aws_iam_policy.s3_policy_read.name,
    arn  = aws_iam_policy.s3_policy_read.arn,
  }
}

output "sqs_policy_send" {
  value = {
    name = aws_iam_policy.sqs_policy_send.name,
    arn  = aws_iam_policy.sqs_policy_send.arn,
  }
}

output "sqs_policy_receive" {
  value = {
    name = aws_iam_policy.sqs_policy_receive.name,
    arn  = aws_iam_policy.sqs_policy_receive.arn,
  }
}


output "sqs_policy_delete" {
  value = {
    name = aws_iam_policy.sqs_policy_delete.name,
    arn  = aws_iam_policy.sqs_policy_delete.arn,
  }
}