output "dynamodb_blocks_policy" {
  value = module.dynamodb.dynamodb_blocks_policy
}

output "dynamodb_car_policy" {
  value = module.dynamodb.dynamodb_car_policy
}

output "blocks_table" {
  value = module.dynamodb.blocks_table
}

output "cars_table" {
  value = module.dynamodb.cars_table
}
