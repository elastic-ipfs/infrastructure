resource "aws_iam_policy" "sqs_event_delivery_queue_receive" {
  name        = var.sqs_event_delivery_queue_policy_receive_name
  description = "Policy for allowing publish messages in SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [         
        {
            "Effect": "Allow",
            "Action": "sqs:ReceiveMessage",
            "Resource": "${aws_sqs_queue.event_delivery_queue.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:GetQueueAttributes",
            "Resource": "${aws_sqs_queue.event_delivery_queue.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "sqs:DeleteMessage",
            "Resource": "${aws_sqs_queue.event_delivery_queue.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sns_event_topic_send" {
  name        = var.sns_event_topic_policy_send_name
  description = "Policy for allowing publish messages in SNS event topic"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "${aws_sns_topic.event_topic.arn}"
        }
    ]
}
EOF
}

resource "aws_sqs_queue_policy" "event_delivery_queue_policy" {
  queue_url = aws_sqs_queue.event_delivery_queue.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.event_delivery_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.event_topic.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "param_store" {
  name        = var.sns_event_topic_policy_send_name
  description = "Policy for allowing publish messages in SNS event topic"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": [
                "${aws_ssm_parameter.event_target_credentials.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:us-west-2:505595374361:key/c7462fb3-65d5-4f2d-a9d1-bdd9d11526fe"
            ]
        }
    ]
}
EOF
}
