output "cars_bucket" {
  value = aws_s3_bucket.cars
}

output "dynamodb_cid_policy" {
  value = module.dynamodb.dynamodb_cid_policy
}

output "dynamodb_car_policy" {
  value = module.dynamodb.dynamodb_car_policy
}
