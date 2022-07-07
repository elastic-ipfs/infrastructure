resource "aws_iam_policy" "sqs_indexer_policy_receive" {
  name        = var.sqs_indexer_policy_receive_name
  description = "Policy for allowing receiving messages from SQS"
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
        },
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.indexer_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_notifications_policy_receive" {
  name        = var.sqs_notifications_policy_receive_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [         
        {
            "Effect": "Allow",
            "Action": "sqs:ReceiveMessage",
            "Resource": "${aws_sqs_queue.notifications_topic.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:GetQueueAttributes",
            "Resource": "${aws_sqs_queue.notifications_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_notifications_policy_delete" {
  name        = var.sqs_notifications_policy_delete_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.notifications_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_notifications_policy_send" {
  name        = var.sqs_notifications_policy_send_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.notifications_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sqs_indexer_policy_send" {
  name        = var.sqs_indexer_policy_send_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.indexer_topic.arn}"
        }
    ]
}
EOF
}
