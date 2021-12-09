resource "aws_iam_role" "uploader_lambda_role" {
  name = "uploader_lambda_role"

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

resource "aws_lambda_permission" "apigw_uploader_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uploader.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${module.api-gateway-to-lambda.execution_arn}/*" 

}

resource "aws_iam_role_policy_attachment" "stripping_s3_policies_attachment" {
  role       = aws_iam_role.uploader_lambda_role.name 
  policy_arn = aws_iam_policy.stripping_s3_policies.arn
}

# resource "aws_iam_role_policy_attachment" "full_access_test" {
#   role       = aws_iam_role.uploader_lambda_role.name 
#   policy_arn = aws_iam_policy.test_s3_admim_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "uploader_s3_write" {
#   role       = aws_iam_role.uploader_lambda_role.name 
#   policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_write.arn
# }

# resource "aws_iam_role_policy_attachment" "uploader_s3_read" {
#   role       = aws_iam_role.uploader_lambda_role.name 
#   policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_read.arn
# }




resource "aws_iam_policy" "stripping_s3_policies" {
  name        = "stripping_s3_policies"
  description = "Policy for allowing all action at S3 ipfs bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": "s3:PutReplicationConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutLifecycleConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketVersioning",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketTagging",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketPolicy",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketOwnershipControls",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketCORS",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutBucketAcl",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:ListBucketVersions",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:ListBucketMultipartUploads",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
      {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetLifecycleConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
     {
            "Effect": "Allow",
            "Action": "s3:GetEncryptionConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetBucketVersioning",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
     {
            "Effect": "Allow",
            "Action": "s3:GetBucketTagging",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetBucketObjectLockConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetBucketLocation",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetBucketCORS",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:GetBucketAcl",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutReplicationConfiguration",
            "Resource": [
              "arn:aws:s3:::ipfs-cars"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectRetention",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },    
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectAcl",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectLegalHold",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectRetention",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectTagging",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectVersionAcl",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
            "Effect": "Allow",
            "Action": "s3:PutObjectVersionTagging",
            "Resource": [
              "arn:aws:s3:::ipfs-cars/*"
            ]              
    },
    {
        "Effect": "Allow",
        "Action": "s3:GetObject",
        "Resource": [
          "arn:aws:s3:::ipfs-cars/*"
        ]              
    },
    {
        "Effect": "Allow",
        "Action": "s3:GetObjectVersion",
        "Resource": [
          "arn:aws:s3:::ipfs-cars/*"
        ]              
    },
    {
        "Effect": "Allow",
        "Action": "s3:ListObjects",
        "Resource": [
          "arn:aws:s3:::ipfs-cars/*"
        ]              
    }
  ]
}
EOF
}




# TODO: If that works, means I'm missing required permissions.. Otherwise might be another problem
# YES, THIS IS A SIMPLE PERMISSIONS PROBLEM
resource "aws_iam_policy" "test_s3_admim_policy" {
  name        = "test_s3_admim_policy"
  description = "Policy for allowing all action at S3 ipfs bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowAllS3ActionsInUserFolder",
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::ipfs-cars",
            "arn:aws:s3:::ipfs-cars/*"
        ]
    }
  ]
}
EOF
}
