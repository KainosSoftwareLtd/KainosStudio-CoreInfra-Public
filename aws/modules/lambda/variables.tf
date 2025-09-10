variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "handler" {
  description = "Handler for the Lambda function (e.g., index.handler)"
  type        = string
}

variable "runtime" {
  description = "Runtime environment for the Lambda function (e.g., nodejs14.x)"
  type        = string
}

variable "memory_size" {
  description = "Memory size for the Lambda function (in MB)"
  type        = number
}

variable "environment_variables" {
  description = "Map of environment variables for the Lambda function"
  type        = map(string)
}

variable "logs_retention_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
}

variable "alias_name" {
  description = "Alias name for the Lambda function (optional)"
  type        = string
  default     = null
}

variable "lambda_execution_role_arn" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}

variable "cloudwatch_kms_key_id" {
  description = "KMS key ID for CloudWatch log group encryption"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "lambda_source_dir" {
  description = "Directory containing Lambda source code (only used for ZIP archives)"
  type        = string
  default     = null
}

variable "publish" {
  description = "Whether to publish a new version of the Lambda function"
  type        = bool
}

variable "filename" {
  description = "Local ZIP path for deployment. Conflicts with image_uri and s3_bucket+s3_key."
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI. Conflicts with filename and S3 sources."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket for ZIP deployment. Requires s3_key."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the deployment package."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "(Optional) version of the S3 object."
  type        = string
  default     = null
}