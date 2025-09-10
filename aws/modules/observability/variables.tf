variable "region" {
  description = "AWS region."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)."
  type        = string
}

variable "app_name" {
  description = "Application name (servicebuilder or coreapp)."
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name (if ECS app)."
  type        = string
  default     = ""
}

variable "ecs_service_name" {
  description = "ECS service name (if ECS app)."
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Lambda function name (if Lambda app)."
  type        = string
  default     = ""
}

variable "log_group_names" {
  description = "List of log group names for which to create log metric filters and widgets."
  type        = list(string)
}

variable "enable_alarms" {
  description = "Enable or disable alarm creation"
  type        = bool
  default     = true
}

variable "external_sns_topic_arn" {
  description = "External SNS topic ARN if reusing existing"
  type        = string
  default     = ""
}

variable "teams_webhook_url" {
  description = "MS Teams Webhook URL for alerts notification"
  type        = string
  default     = ""
}

variable "sns_kms_id" {
  description = "KMS key ID for SNS topic encryption"
  type        = string
  default     = ""
}