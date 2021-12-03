resource "aws_iam_policy" "config_peer_s3_bucket_policy_read" {
  name        = "config-peer-s3-bucket-policy-read"
  description = "Policy for allowing reading objects from S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.ipfs-peer-bitswap-config.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.ipfs-peer-bitswap-config.arn}/*"
        }
    ]
}
EOF
}