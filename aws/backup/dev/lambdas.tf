module "core_lambda" {
  source = "../modules/lambda"
  # checkov:skip=CKV_AWS_117: This is not required to be created in a VPC
  # checkov:skip=CKV_AWS_116: This is not required to be configured for DLQ
  # checkov:skip=CKV_AWS_173: This will be fixed with SSL intergration
  # checkov:skip=CKV_AWS_272: Code Signing is not required
  # checkov:skip=CKV_AWS_115: Code Signing is not required
  # checkov:skip=CKV_AWS_272: Code Signing is not required

  function_name = var.core_lambda_name
  description   = "Kainos Core Application Lambda"
  env           = var.env
  handler       = "lib/lambda.handler"
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory
  environment_variables = {
    CLOUD_PROVIDER               = "aws"
    SESSION_SECRET               = var.session_secret
    BUCKET_NAME                  = local.s3_bucket_kfd_name
    AUTH_CONFIG_FILE_NAME        = var.auth_config_file_name
    BUCKET_NAME_FOR_FORM_FILES   = local.s3_bucket_submitted_form_data_name
    BUCKET_REGION_FOR_FORM_FILES = var.region
    NODE_ENV                     = "production"
    ALLOWED_ORIGIN               = "https://${var.domain}/"
    FORM_SESSION_TABLE_NAME      = local.dynamodb_core_form_sessions_table_name
  }
  logs_retention_days       = var.logs_retention_days
  alias_name                = var.core_lambda_alias
  lambda_execution_role_arn = aws_iam_role.lambda_execution_role.arn
  cloudwatch_kms_key_id     = data.aws_kms_alias.cw.target_key_arn
  tags                      = local.tags

  # S3 source configuration
  s3_bucket = local.s3_bucket_zip_files_name
  s3_key    = "kainoscore-code.zip"

  publish = false
}

module "kfd_api_lambda" {
  source = "../modules/lambda"
  # checkov:skip=CKV_AWS_117: This is not required to be created in a VPC
  # checkov:skip=CKV_AWS_116: This is not required to be configured for DLQ
  # checkov:skip=CKV_AWS_173: This will be fixed with SSL intergration
  # checkov:skip=CKV_AWS_272: Code Signing is not required
  # checkov:skip=CKV_AWS_115: Code Signing is not required
  # checkov:skip=CKV_AWS_272: Code Signing is not required

  function_name = var.kfd_api_lambda_name
  description   = "KFD API Lambda For ${var.env}"
  env           = var.env
  handler       = "lib/lambda.handler"
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory
  environment_variables = {
    CLOUD_PROVIDER = "aws"
    BUCKET_NAME    = local.s3_bucket_kfd_name
    NODE_ENV       = "production"
  }
  logs_retention_days       = var.logs_retention_days
  lambda_execution_role_arn = aws_iam_role.lambda_execution_role.arn
  cloudwatch_kms_key_id     = data.aws_kms_alias.cw.target_key_arn
  tags                      = local.tags

  # S3 source configuration
  s3_bucket = local.s3_bucket_zip_files_name
  s3_key    = "kfd-api.zip"

  publish = false
}