output "lambdaRoleName" {
    value = aws_iam_role.indexing_lambda_role.name
    description = "The name of the Indexing Lambda"
}
