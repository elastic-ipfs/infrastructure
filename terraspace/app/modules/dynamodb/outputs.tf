output "dynamodb_blocks_policy" {
  value = aws_iam_policy.dynamodb_blocks_policy
}

output "dynamodb_car_policy" {
  value = aws_iam_policy.dynamodb_car_policy
}

output "blocks_table" {
  value = aws_dynamodb_table.blocks_table
}

output "cars_table" {
  value = aws_dynamodb_table.cars_table
}
