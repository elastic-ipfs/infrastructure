resource "aws_iam_policy" "dynamodb_config_policy" {
  name        = "dynamodb-${var.config_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for config table"
  policy      = <<EOF
{  
  "Version": "2012-10-17",
  "Statement":[{
    "Effect": "Allow",
    "Action": [
     "dynamodb:BatchGetItem",
     "dynamodb:GetItem",
     "dynamodb:Query",
     "dynamodb:Scan",
     "dynamodb:BatchWriteItem",
     "dynamodb:PutItem",
     "dynamodb:UpdateItem"
    ],
    "Resource": "${aws_dynamodb_table.config_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}
