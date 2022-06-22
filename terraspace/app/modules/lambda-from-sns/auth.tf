resource "aws_iam_role" "lambda_function_lambda_role" {
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

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "sns.amazonaws.com"
  source_arn    = data.aws_sns_topic.source_sns_topic.arn
}

resource "aws_iam_role_policy_attachment" "policies_attach" {
  for_each   = { for policy in var.lambda.policies_list : policy.name => policy }
  role       = aws_iam_role.lambda_function_lambda_role.name
  policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "lambda_function_lambda_role" {
  role       = aws_iam_role.lambda_function_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  role       = aws_iam_role.lambda_function_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}
