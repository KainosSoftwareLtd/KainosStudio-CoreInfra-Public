module "basic_lambda" {
  source = "../modules/lambda"

  function_name = "basicLambda"
  description   = "A basic AWS Lambda function"
  env           = "dev"
  handler       = "index.handler" # Required
  runtime       = "nodejs14.x"    # Required
  memory_size   = 256             # Required
  environment_variables = {
    NODE_ENV  = "development"
    LOG_LEVEL = "info"
  }
  logs_retention_days       = 30 # Required
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "development"
    Project     = "BasicProject"
  }
  lambda_source_dir = "lambdas/basic/"
  publish           = true
}
