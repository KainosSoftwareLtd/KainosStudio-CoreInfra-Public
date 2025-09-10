# Defines the main API Gateway REST API
resource "aws_api_gateway_rest_api" "core_api" {
  name        = "${var.api_core_name}${var.env}"
  description = "API Gateway for Kainos Core"
  endpoint_configuration {
    types = ["EDGE"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags

}

# Creates a proxy resource to handle all subpaths (/{proxy+})
resource "aws_api_gateway_resource" "core_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.core_api.id
  parent_id   = aws_api_gateway_rest_api.core_api.root_resource_id
  path_part   = "{proxy+}"
}

# CloudWatch log group for general API Gateway logs
resource "aws_cloudwatch_log_group" "core_api_log_group" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.core_api.name}"
  retention_in_days = var.logs_retention_days
  kms_key_id        = data.aws_kms_alias.cw.target_key_arn
}

# CloudWatch log group for API execution logs
resource "aws_cloudwatch_log_group" "core_api_execution_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.core_api.id}/${var.env}"
  retention_in_days = var.logs_retention_days
  kms_key_id        = data.aws_kms_alias.cw.target_key_arn
}

# Defines the GET method for the root resource
resource "aws_api_gateway_method" "core_root_method" {
  # checkov:skip=CKV_AWS_59: Using CloudFront for access control
  # checkov:skip=CKV2_AWS_53: Using CloudFront for access control
  rest_api_id   = aws_api_gateway_rest_api.core_api.id
  resource_id   = aws_api_gateway_rest_api.core_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Defines the ANY method for the /{proxy+} resource
resource "aws_api_gateway_method" "core_proxy_method" {
  # checkov:skip=CKV_AWS_59: Using CloudFront for access control
  # checkov:skip=CKV2_AWS_53: Using CloudFront for access control

  rest_api_id   = aws_api_gateway_rest_api.core_api.id
  resource_id   = aws_api_gateway_resource.core_proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integration between GET method on root and a Lambda function
resource "aws_api_gateway_integration" "core_put_method_root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.core_api.id
  resource_id             = aws_api_gateway_rest_api.core_api.root_resource_id
  http_method             = aws_api_gateway_method.core_root_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.core_lambda.lambda_function_arn}/invocations"
}

# Integration between ANY method on /{proxy+} and a Lambda function
resource "aws_api_gateway_integration" "core_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.core_api.id
  resource_id             = aws_api_gateway_resource.core_proxy_resource.id
  http_method             = aws_api_gateway_method.core_proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.core_lambda.lambda_function_arn}/invocations"
}

# Grants API Gateway permission to invoke Lambda for GET method
resource "aws_lambda_permission" "core_apigw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = module.core_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com" # 
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.core_api.id}/*/GET/"
}

# Grants API Gateway permission to invoke Lambda for ANY method
resource "aws_lambda_permission" "core_apigw_lambda_any" {
  statement_id  = "AllowExecutionFromAPIGatewayAny"
  action        = "lambda:InvokeFunction"
  function_name = module.core_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.core_api.id}/*/*/*"
}

# Deploys the API Gateway
resource "aws_api_gateway_deployment" "core_deployment" {
  depends_on = [
    aws_api_gateway_method.core_root_method,
    aws_api_gateway_integration.core_put_method_root_integration,
    aws_api_gateway_method.core_proxy_method,
    aws_api_gateway_integration.core_proxy_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.core_api.id
  description = "Deployment of the KainosCore API"
  lifecycle {
    create_before_destroy = true
  }
}

# Configures the API Gateway stage
resource "aws_api_gateway_stage" "core_stage" {
  stage_name           = var.core_stage
  rest_api_id          = aws_api_gateway_rest_api.core_api.id
  deployment_id        = aws_api_gateway_deployment.core_deployment.id
  description          = "Api Stage for ${aws_api_gateway_rest_api.core_api.name}"
  xray_tracing_enabled = true
  # checkov:skip=CKV_AWS_120: Caching Not Required
  # checkov:skip=CKV2_AWS_51: This Might be Looked into in the future
  # checkov:skip=CKV2_AWS_29: WAF Not Required but will be looked into in the future for Prod


  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.core_api_log_group.arn                                                                                                                                                                                                           # Destination for access logs
    format          = "$context.extendedRequestId $context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId" # Log format
  }
}

# Restricts API Gateway access to CloudFront in production and prod
resource "aws_api_gateway_rest_api_policy" "restrict_to_cloudfront" {
  count       = var.env == "staging" || var.env == "prod" ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.core_api.id
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.core_api.id}/*",
        "Condition": {
          "StringEquals": {
            "aws:SourceArn": "${aws_cloudfront_distribution.distribution.arn}"
          }
        }
      },
      {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.core_api.id}/*",
        "Condition": {
          "StringNotEquals": {
            "aws:SourceArn": "${aws_cloudfront_distribution.distribution.arn}"
          }
        }
      }
    ]
  }
  EOF
}


# Configures method-level settings for the API stage
resource "aws_api_gateway_method_settings" "core_all" {
  rest_api_id = aws_api_gateway_rest_api.core_api.id
  stage_name  = aws_api_gateway_stage.core_stage.stage_name
  method_path = "*/*"
  # checkov:skip=CKV_AWS_225: Caching Not Required

  settings {
    metrics_enabled      = true
    logging_level        = "INFO"
    cache_data_encrypted = true

  }
}
# apigateway_account

resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_logging_role.arn
}

# Outputs the API Gateway ID
output "core_api_gateway_id" {
  value = aws_api_gateway_rest_api.core_api.id
}

# Outputs the root resource ID of the API Gateway
output "core_api_gateway_root_resource_id" {
  value = aws_api_gateway_rest_api.core_api.root_resource_id
}