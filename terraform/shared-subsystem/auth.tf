resource "aws_iam_policy" "s3_policy_write" {
  name        = "s3-policy-write"
  description = "Policy for allowing put objects at S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cars.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_policy_read" {
  name        = "s3-policy-read"
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.cars.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.cars.arn}/*"
        }
    ]
}
EOF
}
