locals {
  source_count = length(compact([
    var.filename != null ? "filename" : null,
    var.image_uri != null ? "image_uri" : null,
    (var.s3_bucket != null && var.s3_key != null) ? "s3" : null,
  ]))

  # Determine which source to use
  use_filename  = var.filename != null
  use_s3        = var.s3_bucket != null && var.s3_key != null
  use_image     = var.image_uri != null
  use_local_zip = var.lambda_source_dir != null && !local.use_filename && !local.use_s3 && !local.use_image
}

resource "null_resource" "source_validation" {
  count = local.source_count == 1 ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: Exactly one of filename, image_uri, or (s3_bucket + s3_key) must be set' && exit 1"
  }
}

# Only build the ZIP if using local source directory (not filename, S3, or image)
data "archive_file" "lambda" {
  count       = local.use_local_zip ? 1 : 0
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/lambda_payload_${var.function_name}.zip"
}

# Define the Lambda function
resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-${var.env}"
  description   = var.description
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  publish       = var.publish

  # Exclusive source arguments
  filename          = local.use_filename ? var.filename : (local.use_local_zip ? data.archive_file.lambda[0].output_path : null)
  image_uri         = local.use_image ? var.image_uri : null
  s3_bucket         = local.use_s3 ? var.s3_bucket : null
  s3_key            = local.use_s3 ? var.s3_key : null
  s3_object_version = local.use_s3 ? var.s3_object_version : null

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      s3_bucket,
      s3_key,
      s3_object_version
    ]
  }
  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = "Active"
  }

  tags = var.tags
}

# Conditionally create an alias if alias_name is provided
resource "aws_lambda_alias" "alias" {
  count            = var.alias_name != null ? 1 : 0
  name             = var.alias_name
  description      = "Alias for ${var.function_name}-${var.env}"
  function_name    = aws_lambda_function.lambda.function_name
  function_version = aws_lambda_function.lambda.version
}

# Define a CloudWatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.function_name}-${var.env}"
  retention_in_days = var.logs_retention_days
  kms_key_id        = var.cloudwatch_kms_key_id

  tags = var.tags
}