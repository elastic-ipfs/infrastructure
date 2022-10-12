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

resource "aws_iam_policy" "s3_e2e_policy_write" {
  name        = var.s3_e2e_policy_write_name
  description = "Policy for allowing write objects to S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}"
        },
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListObjects",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListMultipartUploadParts",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:AbortMultipartUpload",
            "Resource": "${aws_s3_bucket.peer_e2e_tests.arn}/*"
        }        
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_role_attach" {
  role       = aws_iam_role.ec2_role_atc.name
  policy_arn = aws_iam_policy.s3_e2e_policy_write.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_instance_name}-profile"
  role = aws_iam_role.ec2_role_atc.name
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.ec2_role_atc.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
