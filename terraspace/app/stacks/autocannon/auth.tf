resource "aws_iam_role" "ec2_role_atc" {
  name = "${var.ec2_instance_name}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_instance_name}_profile"
  role = aws_iam_role.ec2_role_atc.name
}
