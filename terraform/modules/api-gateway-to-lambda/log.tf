data "aws_iam_policy" "api_gateway_loging" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_cloudwatch_log_group" "indexing_api_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.upload_cars_api.id}/${local.stage_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "api_gateway_loging_attach" {
  role       = aws_iam_role.s3_api_gateyway_role.name
  policy_arn = data.aws_iam_policy.api_gateway_loging.arn
}

resource "aws_api_gateway_account" "api_gateway_cloudwatch_account" {
  cloudwatch_role_arn = aws_iam_role.s3_api_gateyway_role.arn
}

resource "aws_api_gateway_method_settings" "api_gateway_enable_log" {
  rest_api_id = aws_api_gateway_rest_api.upload_cars_api.id
  stage_name  = aws_api_gateway_stage.v1.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50 # Concurrent requests
  }
}
