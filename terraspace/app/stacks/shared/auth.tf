resource "aws_iam_policy" "sqs_multihashes_policy_send" {
  name        = var.multihashes_send_policy_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.multihashes_topic.arn}"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "sqs_multihashes_policy_receive" {
  name        = var.multihashes_receive_policy_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:ReceiveMessage",
            "Resource": "${aws_sqs_queue.multihashes_topic.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:GetQueueAttributes",
            "Resource": "${aws_sqs_queue.multihashes_topic.arn}"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "sqs_multihashes_policy_delete" {
  name        = var.multihashes_delete_policy_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.multihashes_topic.arn}"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "s3_config_peer_bucket_policy_read" {
  name        = var.config_bucket_read_policy_name
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.ipfs_peer_bitswap_config.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.ipfs_peer_bitswap_config.arn}/*"
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

# TODO: Move this policy to future *.storage IaC
# Could use 'dynamic' for creating statements for as many buckets as possible (start handling that as a list)
# https://stackoverflow.com/questions/62184180/terraform-is-there-a-way-to-create-iam-policy-statements-dynamically
resource "aws_iam_policy" "s3_dotstorage_policy_read" {
  name        = var.dotstorage_bucket_read_policy_name
  description = "Policy for allowing reading objects from S3"
  policy = data.aws_iam_policy_document.s3_dotstorage_policy_read.json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "s3_dotstorage_policy_read" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [ for bucket in var.storage_bucket_names : "arn:aws:s3:::${bucket}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListObjects",
    ]
    resources = [ for bucket in var.storage_bucket_names : "arn:aws:s3:::${bucket}/*"]
  }
}


resource "aws_iam_policy" "dynamodb_v1_blocks_policy" {
  name        = "dynamodb-${var.v1_blocks_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for blocks table"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[{
    "Effect": "Allow",
    "Action": [
     "dynamodb:BatchGetItem",
     "dynamodb:GetItem",
     "dynamodb:Query",
     "dynamodb:Scan",
     "dynamodb:BatchWriteItem",
     "dynamodb:PutItem",
     "dynamodb:UpdateItem",
     "dynamodb:DeleteItem"
    ],
    "Resource": "${aws_dynamodb_table.v1_blocks_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "dynamodb_v1_cars_policy" {
  name        = "dynamodb-${var.v1_cars_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for CAR table"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[{
    "Effect": "Allow",
    "Action": [
     "dynamodb:BatchGetItem",
     "dynamodb:GetItem",
     "dynamodb:Query",
     "dynamodb:Scan",
     "dynamodb:BatchWriteItem",
     "dynamodb:PutItem",
     "dynamodb:UpdateItem"
    ],
    "Resource": "${aws_dynamodb_table.v1_cars_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_policy" "dynamodb_v1_link_policy" {
  name        = "dynamodb-${var.v1_link_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for CAR table"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[{
    "Effect": "Allow",
    "Action": [
     "dynamodb:BatchGetItem",
     "dynamodb:GetItem",
     "dynamodb:Query",
     "dynamodb:Scan",
     "dynamodb:BatchWriteItem",
     "dynamodb:PutItem",
     "dynamodb:UpdateItem"
    ],
    "Resource": "${aws_dynamodb_table.v1_link_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}
