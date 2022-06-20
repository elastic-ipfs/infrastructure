resource "aws_iam_policy" "dynamodb_blocks_policy" {
  name        = "dynamodb-${var.blocks_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for blocks table"
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
     "dynamodb:UpdateItem",
     "dynamodb:DeleteItem"
    ],
    "Resource": "${aws_dynamodb_table.blocks_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "dynamodb_car_policy" {
  name        = "dynamodb-${var.cars_table.name}-policy"
  description = "Policy for allowing all Dynamodb Actions for CAR table"
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
    "Resource": "${aws_dynamodb_table.cars_table.arn}"
   }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}
