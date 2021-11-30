resource "aws_iam_role" "peer_subsystem_role" {
  name = "peer_subsystem_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policies_attach" {
  for_each = { for policy in var.aws_iam_role_policy_list: policy.name => policy }
  role       = aws_iam_role.peer_subsystem_role.name
  policy_arn = each.value.arn
}
