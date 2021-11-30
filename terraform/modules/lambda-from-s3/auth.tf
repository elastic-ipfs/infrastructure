resource "aws_iam_role" "indexing_lambda_role" {
  name = "indexing_lambda_role"

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

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.indexing.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket.arn
}

resource "aws_iam_role_policy_attachment" "policies_attach" {
  for_each = { for policy in var.aws_iam_role_policy_list: policy.name => policy }
  role       = aws_iam_role.indexing_lambda_role.name
  policy_arn = each.value.arn
}


## TODO: Isso vai ficar no loop das permissões que a role deve receber
# resource "aws_iam_role_policy_attachment" "dynamodb_cid_policy_attach" {
#   role       = var.lambdaRoleName
#   policy_arn = aws_iam_policy.dynamodb_cid_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "dynamodb_car_policy_attach" {
#   role       = var.lambdaRoleName
#   policy_arn = aws_iam_policy.dynamodb_car_policy.arn
# }
