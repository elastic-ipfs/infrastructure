resource "aws_iam_policy" "terratest_s3_policy_write" {
  name        = "terratest-s3-policy-write"
  description = "Policy for allowing put objects at S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.terratest_lambda_from_s3_cars.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "terratest_s3_policy_read" {
  name        = "terratest-s3-policy-read"
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.terratest_lambda_from_s3_cars.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.terratest_lambda_from_s3_cars.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.terratest_lambda_from_s3_cars.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "terratest_sqs_policy_send" {
  name        = "terratest-sqs-policy-send"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.terratest_lambda_from_s3_multihashes_topic.arn}"
        }
    ]
}
EOF
}
