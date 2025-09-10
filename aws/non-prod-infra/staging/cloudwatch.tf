module "observability_coreapp" {
  source                 = "../../modules/observability"
  region                 = var.region
  environment            = var.env
  app_name               = "coreapp"
  lambda_function_name   = module.core_lambda.lambda_function_name
  log_group_names        = [module.core_lambda.lambda_log_group_name]
  sns_kms_id             = data.aws_kms_alias.sns.target_key_arn
  external_sns_topic_arn = "arn:aws:sns:eu-west-2:975050265283:staging-alerts-topic"
}