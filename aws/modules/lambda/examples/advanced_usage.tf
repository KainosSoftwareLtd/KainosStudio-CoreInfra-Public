module "advanced_lambda" {
  source = "../modules/lambda"

  function_name = "advancedLambda"
  description   = "An advanced AWS Lambda function with alias and extended configurations"
  env           = "prod"
  handler       = "app.handler" # Required
  runtime       = "python3.8"   # Required
  memory_size   = 512           # Required
  environment_variables = {
    DATABASE_URL          = "postgres://user:password@db.example.com:5432/mydb"
    API_KEY               = "supersecretapikey"
    FEATURE_FLAG_ENABLE_X = "true"
    LOG_LEVEL             = "debug"
    NODE_ENV              = "production"
  }
  logs_retention_days       = 14       # Required
  alias_name                = "stable" # Optional
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "production"
    Project     = "AdvancedProject"
    Owner       = "DevOpsTeam"
    Compliance  = "PCI-DSS"
  }
  lambda_source_dir = "lambdas/advanced/"
  publish           = true
}
