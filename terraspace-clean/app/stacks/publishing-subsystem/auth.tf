### Policies
resource "aws_iam_policy" "s3_ads_policy_write" {
  name        = "s3-ads-policy-write"
  description = "Policy for allowing put objects in S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.ipfs_peer_ads.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_ads_policy_read" {
  name        = "s3-ads-policy-read"
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.ipfs_peer_ads.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.ipfs_peer_ads.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.ipfs_peer_ads.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_ads_policy_send" {
  name        = "sqs-ads-policy-send"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.ads_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_ads_policy_receive" {
  name        = "sqs-ads-policy-receive"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [         
        {
            "Effect": "Allow",
            "Action": "sqs:ReceiveMessage",
            "Resource": "${aws_sqs_queue.ads_topic.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:GetQueueAttributes",
            "Resource": "${aws_sqs_queue.ads_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_ads_policy_delete" {
  name        = "sqs-ads-policy-delete"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.ads_topic.arn}"
        }
    ]
}
EOF
}

### Bucket

data "aws_iam_policy_document" "s3_advertisment_files_public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.ipfs_peer_ads.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_policy" "allow_public_access_to_files" {
  bucket = aws_s3_bucket.ipfs_peer_ads.id
  policy = data.aws_iam_policy_document.s3_advertisment_files_public_access.json
}
