resource "aws_iam_policy" "dynamodb_cid_policy" {
  name        = "dynamodb-cid-policy"
  description = "Policy for allowing all Dynamodb Actions for CID table"
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
    "Resource": "${aws_dynamodb_table.blocks_table.arn}"
   }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamodb_cid_policy_attach" {
  role       = var.lambdaRoleName
  policy_arn = aws_iam_policy.dynamodb_cid_policy.arn
}
