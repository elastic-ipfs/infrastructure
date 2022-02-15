### Roles
resource "aws_iam_role" "content_lambda_role" {
  name = "content_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ads_lambda_role" {
  name = "ads_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

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

### Attachments
# TODO: Attach READ and DELETE permissions from shared multihashed topics to content publishing lambda
resource "aws_iam_role_policy_attachment" "content_insights" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "content_sqs_multihash_receive" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = data.terraform_remote_state.shared.outputs.sqs_policy_receive.arn
}

resource "aws_iam_role_policy_attachment" "content_sqs_multihash_delete" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = data.terraform_remote_state.shared.outputs.sqs_policy_delete.arn
}

resource "aws_iam_role_policy_attachment" "content_s3_read" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = aws_iam_policy.s3_ads_policy_read.arn
}


resource "aws_iam_role_policy_attachment" "content_s3_write" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = aws_iam_policy.s3_ads_policy_write.arn
}

resource "aws_iam_role_policy_attachment" "content_sqs_send" {
  role       = aws_iam_role.content_lambda_role.id
  policy_arn = aws_iam_policy.sqs_ads_policy_send.arn
}

resource "aws_iam_role_policy_attachment" "ads_insights" {
  role       = aws_iam_role.ads_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ads_s3_write" {
  role       = aws_iam_role.ads_lambda_role.id
  policy_arn = aws_iam_policy.s3_ads_policy_write.arn
}

resource "aws_iam_role_policy_attachment" "ads_s3_read" {
  role       = aws_iam_role.ads_lambda_role.id
  policy_arn = aws_iam_policy.s3_ads_policy_read.arn
}

resource "aws_iam_role_policy_attachment" "ads_sqs_receive" {
  role       = aws_iam_role.ads_lambda_role.id
  policy_arn = aws_iam_policy.sqs_ads_policy_receive.arn
}

resource "aws_iam_role_policy_attachment" "ads_sqs_delete" {
  role       = aws_iam_role.ads_lambda_role.id
  policy_arn = aws_iam_policy.sqs_ads_policy_delete.arn
}
