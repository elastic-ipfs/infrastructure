resource "aws_iam_policy" "sqs_multihashes_policy_send" {
  name        = "sqs-multihashes-policy-send"
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
}

resource "aws_iam_policy" "sqs_multihashes_policy_receive" {
  name        = "sqs-multihashes-policy-receive"
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
}

resource "aws_iam_policy" "sqs_multihashes_policy_delete" {
  name        = "sqs-multihashes-policy-delete"
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
}

resource "aws_iam_policy" "s3_config_peer_bucket_policy_read" {
  name        = "s3-config-peer-bucket-policy-read"
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
}
