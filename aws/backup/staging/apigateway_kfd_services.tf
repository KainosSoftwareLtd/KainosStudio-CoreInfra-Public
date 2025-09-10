resource "aws_api_gateway_rest_api" "kfd_api" {
  name        = "${var.api_kfd_name}${var.env}"
  description = "API Gateway For KFD Services"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.apigateway_vpc_endpoint]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

resource "aws_api_gateway_resource" "kfd_services" {
  rest_api_id = aws_api_gateway_rest_api.kfd_api.id
  parent_id   = aws_api_gateway_rest_api.kfd_api.root_resource_id
  path_part   = "services"
}

resource "aws_api_gateway_resource" "kfd_services_id" {
  rest_api_id = aws_api_gateway_rest_api.kfd_api.id
  parent_id   = aws_api_gateway_resource.kfd_services.id
  path_part   = "{id}"
}

resource "aws_cloudwatch_log_group" "kfd_api_log_group" {
  name              = "/aws/apigateway/${var.api_kfd_name}${var.env}"
  retention_in_days = var.logs_retention_days
  kms_key_id        = data.aws_kms_alias.cw.target_key_arn
}

resource "aws_cloudwatch_log_group" "kfd_api_execution_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.kfd_api.id}/${var.env}"
  retention_in_days = var.logs_retention_days
  kms_key_id        = data.aws_kms_alias.cw.target_key_arn
}

resource "aws_api_gateway_method" "kfd_put_method_root" {
  # checkov:skip=CKV_AWS_59: Using Cloudfront For Access
  # checkov:skip=CKV2_AWS_53: Using CloudFront for access control

  rest_api_id   = aws_api_gateway_rest_api.kfd_api.id
  resource_id   = aws_api_gateway_resource.kfd_services.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "kfd_put_method_root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.kfd_api.id
  resource_id             = aws_api_gateway_resource.kfd_services.id
  http_method             = aws_api_gateway_method.kfd_put_method_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.kfd_api_lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_method" "kfd_delete_method_services_id" {
  # checkov:skip=CKV_AWS_59: Using Cloudfront For Access
  # checkov:skip=CKV2_AWS_53: Using CloudFront for access control

  rest_api_id   = aws_api_gateway_rest_api.kfd_api.id
  resource_id   = aws_api_gateway_resource.kfd_services_id.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}


resource "aws_api_gateway_integration" "kfd_delete_method_services_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.kfd_api.id
  resource_id             = aws_api_gateway_resource.kfd_services_id.id
  http_method             = aws_api_gateway_method.kfd_delete_method_services_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.kfd_api_lambda.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_deployment" "kfd_deployment" {
  depends_on = [
    aws_api_gateway_method.kfd_put_method_root,
    aws_api_gateway_method.kfd_delete_method_services_id,
    aws_api_gateway_integration.kfd_put_method_root_integration,
    aws_api_gateway_integration.kfd_delete_method_services_id_integration

  ]
  rest_api_id = aws_api_gateway_rest_api.kfd_api.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "kfd_stage" {
  # checkov:skip=CKV_AWS_120: Caching is not required
  rest_api_id          = aws_api_gateway_rest_api.kfd_api.id
  deployment_id        = aws_api_gateway_deployment.kfd_deployment.id
  stage_name           = var.env
  description          = "Api Stage for ${var.api_kfd_name}${var.env}"
  xray_tracing_enabled = true
  lifecycle {
    ignore_changes = [deployment_id]
  }

  # checkov:skip=CKV2_AWS_51: This Might be Looked into in the future
  # checkov:skip=CKV2_AWS_29: WAF Not Required but will be looked into in the future for Prod

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.kfd_api_log_group.arn
    format          = "$context.extendedRequestId $context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId"
  }
}

resource "aws_api_gateway_method_settings" "kfd_all" {
  rest_api_id = aws_api_gateway_rest_api.kfd_api.id
  stage_name  = aws_api_gateway_stage.kfd_stage.stage_name
  method_path = "*/*"
  # checkov:skip=CKV_AWS_225: Caching is not required
  settings {
    metrics_enabled      = true
    logging_level        = "INFO"
    cache_data_encrypted = true
  }
}

resource "aws_lambda_permission" "kfd_upload_trigger" {
  statement_id  = "AllowApiGatewayPut"
  action        = "lambda:InvokeFunction"
  function_name = module.kfd_api_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.kfd_api.id}/*/PUT/services"
}

resource "aws_lambda_permission" "kfd_delete_trigger" {
  statement_id  = "AllowApiGatewayDelete"
  action        = "lambda:InvokeFunction"
  function_name = module.kfd_api_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.kfd_api.id}/*/DELETE/services/*"
}

resource "aws_api_gateway_rest_api_policy" "restrict_to_vpc" {
  rest_api_id = aws_api_gateway_rest_api.kfd_api.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "execute-api:Invoke"
        Resource  = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.kfd_api.id}/*/*/*"
        Condition = {
          StringNotEquals = {
            "aws:SourceVpc" = var.prod_vpc_id
          }
        }
      },
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "execute-api:Invoke"
        Resource  = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.kfd_api.id}/*/*/*"
      }
    ]
  })
}


output "kfd_api_gateway_id" {
  value = aws_api_gateway_rest_api.kfd_api.id
}

output "kfd_api_gateway_root_resource_id" {
  value = aws_api_gateway_rest_api.kfd_api.root_resource_id
}


