resource "aws_iam_role" "s3_api_gateyway_role" {
  name = "s3-api-gateyway-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
} 
EOF
}


resource "aws_iam_role_policy_attachment" "policies_attach" {
  for_each = { for policy in var.aws_iam_role_policy_list: policy.name => policy }
  role       = aws_iam_role.s3_api_gateyway_role.name
  policy_arn = each.value.arn
}
