resource "aws_lambda_function" "content" {
  function_name = local.content_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = "?"
  handler       = "index.handler"
  runtime       = "nodejs14.x"  

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]
}


resource "aws_sqs_queue" "advertisements_topic" {
  name                      = "advertisements_topic"
  receive_wait_time_seconds = 10
}

resource "aws_lambda_function" "advertisement" {
  function_name = local.advertisement_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = "?"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  reserved_concurrent_executions = 1 # https://docs.aws.amazon.com/lambda/latest/operatorguide/reserved-concurrency.html

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]
}

