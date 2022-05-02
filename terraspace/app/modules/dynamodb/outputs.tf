output "dynamodb_blocks_policy" {
  value       = aws_iam_policy.dynamodb_blocks_policy
  description = "Policy for allowing all Dynamodb Actions for blocks table"
}

output "dynamodb_car_policy" {
  value       = aws_iam_policy.dynamodb_car_policy
  description = "Policy for allowing all Dynamodb Actions for cars table"
}

output "blocks_table" {
  value       = aws_dynamodb_table.blocks_table
  description = "Dynamodb blocks table object"
}

output "cars_table" {
  value       = aws_dynamodb_table.cars_table
  description = "Dynamodb cars table object"
}
