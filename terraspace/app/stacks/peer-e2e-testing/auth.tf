resource "aws_iam_role" "ec2_role_atc" {
  name = "${var.ec2_instance_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_instance_name}-profile"
  role = aws_iam_role.ec2_role_atc.name
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.ec2_role_atc.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
