data "aws_iam_policy" "api_gateway_loging" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "api_gateway_loging_attach" {
  role       = aws_iam_role.s3_api_gateyway_role.name
  policy_arn = data.aws_iam_policy.api_gateway_loging.arn
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.s3_api_gateyway_role.arn
}

resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.cars_api.id
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
