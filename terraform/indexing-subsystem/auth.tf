resource "aws_iam_policy" "sqs_indexer_policy_receive" {
  name        = "sqs-indexer-policy-receive"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [         
        {
            "Effect": "Allow",
            "Action": "sqs:ReceiveMessage",
            "Resource": "${aws_sqs_queue.indexer_topic.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:GetQueueAttributes",
            "Resource": "${aws_sqs_queue.indexer_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_indexer_policy_delete" {
  name        = "sqs-indexer-policy-delete"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.indexer_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_dotstorage_prod_0_policy_read" {
  name        = "s3-dotstorage-prod-0-policy-read"
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::dotstorage-prod-0"
        },
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::dotstorage-prod-0/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "arn:aws:s3:::dotstorage-prod-0/*"
        }
    ]
}
EOF
}