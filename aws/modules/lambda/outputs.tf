
# Outputs
output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "lambda_alias_arn" {
  description = "ARN of the Lambda alias"
  value       = var.alias_name != null ? aws_lambda_alias.alias[0].arn : null
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "lambda_version" {
  description = "Version of the Lambda function"
  value       = aws_lambda_function.lambda.version
}

output "lambda_log_group_name" {
  description = "Core App cloudwatch log group name"
  value       = aws_cloudwatch_log_group.log_group.name
}