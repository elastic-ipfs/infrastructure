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


resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each   = var.lambda.policies_list
  role       = aws_iam_role.lambda_role.id
  policy_arn = each.value.arn
}
