resource "aws_lambda_event_source_mapping" "event_triggers" {
  event_source_arn                   = var.sqs_trigger.arn
  enabled                            = true
  function_name                      = aws_lambda_function.lambda.arn
  batch_size                         = var.sqs_trigger.batch_size
  maximum_batching_window_in_seconds = var.sqs_trigger.maximum_batching_window_in_seconds
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda.name
  package_type = "Image"                 
  image_uri    = var.lambda.image_uri
  role         = aws_iam_role.lambda_role.arn
  memory_size  = var.lambda.memory_size
  timeout      = var.lambda.timeout

  environment {
    variables = var.lambda.environment_variables
  }
}
