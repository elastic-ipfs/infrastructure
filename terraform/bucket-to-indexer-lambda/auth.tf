resource "aws_iam_policy" "sqs_indexer_policy_send" {
  name        = "sqs-indexer-policy-send"
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${data.terraform_remote_state.indexing.outputs.sqs_indexer_topic.arn}"
        }
    ]
}
EOF
}