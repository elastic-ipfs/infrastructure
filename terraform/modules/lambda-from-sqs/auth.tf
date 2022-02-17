resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda.name}_role"

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


resource "aws_iam_role_policy_attachment" "policy_attach" {
  for_each   = { for policy in var.lambda.policies_list : policy.name => policy }
  role       = aws_iam_role.lambda_role.id
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "content_insights" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}
