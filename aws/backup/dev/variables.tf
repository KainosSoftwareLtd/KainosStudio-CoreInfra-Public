############################################################
# General Variables
############################################################

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

#====== Core Variables ======
variable "api_core_name" {
  type        = string
  description = "API Gateway For Fabric/Kainos Core"
  default     = "kainoscore-api-"
}

variable "core_stage" {
  type        = string
  description = "API Gateway Stage For Fabric/Kainos Core"
  default     = "uat"
}

variable "waf_acl_name" {
  type        = string
  description = "WAF ACL Name"
  default     = "cloudfront-waf-acl"
}

variable "api_gateway_logging_role_name" {
  type        = string
  description = "API Gateway Logging Role"
  default     = "kainoscore-api-gateway-logging-role"
}

variable "dev_vpc_id" {
  type        = string
  description = "Dev2 ENV VPC ID"
  default     = "vpc-0bd55d5f39a1e7810"
}

variable "dev_private_subnet_id" {
  type        = string
  description = "Dev2 ENV Private Subnet ID"
  default     = "subnet-01b6c2037f4715ae5"
}

variable "dev_codebuild_security_group_id" {
  type        = string
  description = "Dev ENV Codebuild Security Group ID"
  default     = "sg-0eae679444d3b8d25"

}

variable "gha_codebuild_service_role_name" {
  type        = string
  description = "CodeBuild Service Role"
  default     = "GHA-CodeBuild-Service-Role"

}

variable "logs_retention_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 365
}

variable "creator" {
  type        = string
  description = "Identifier for the creator of these resources"
  default     = "Terraform"
}

variable "kms_s3_alias" {
  description = "KMS Key Alias for s3"
  type        = string
  default     = "alias/kainoscore-s3-kms"
}

variable "kms_sns_topic_alias" {
  description = "KMS Key Alias for SNS topic"
  type        = string
  default     = "alias/sns-topic-kms"
}

variable "kms_cw_alias" {
  description = "KMS Key Alias for cloudwatch"
  type        = string
  default     = "alias/kainoscore-cw-kms"
}

variable "provider_assume_role" {
  description = "Whether the provider should assume Codebuild Deployment role"
  default     = false
  type        = bool
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume"
  type        = string
  default     = "arn:aws:iam::696793786584:role/GHA-CodeBuild-Service-Role"
}

variable "apigateway_vpc_endpoint" {
  type        = string
  description = "API Gateway VPC Endpoint"
}

#====== apigateway-kfd-services Variables ======
variable "api_kfd_name" {
  type        = string
  description = "API For KFD"
  default     = "kainoscore-kfd-services-"
}

# (Note: api_kfd_name, api_fabric_name, region, env, logs_retention_days, creator already defined above)

variable "cloudfront_stage" {
  type        = string
  description = "API stage to connect CloudFront to"
  default     = "/uat"
}

variable "domain" {
  description = "Cloudfront Alias Domain"
  type        = string
}

variable "certificate_arn" {
  description = "SSL Certificate Manager ARN"
  type        = string
}

variable "cloudfront_access_control_name" {
  type        = string
  description = "Name for the CloudFront Origin Access Control"
  default     = "Core-Access-Control-"
}

variable "cloudfront_s3_policy_name" {
  type        = string
  description = "Name for the CloudFront S3 Cache Policy"
  default     = "Core-S3-Cache-Policy-"
}


# variable "domain" {
#   type        = string
#   description = "Domain name associated with the CloudFront distribution"
# }

# variable "certificate_arn" {
#   type        = string
#   description = "ARN of the ACM certificate for CloudFront"
# }


#====== iam-roles Variables ======
variable "lambda_role_name" {
  type        = string
  description = "Role Name for Lambdas"
  default     = "kainoscore-Lambda-Role"
}


#====== lambda Variables ======
variable "kfd_api_lambda_name" {
  type        = string
  description = "Name of the KFD API Lambda function"
  default     = "kainoscore-kfd-api"
}

variable "core_lambda_name" {
  type        = string
  description = "Name of the Core Lambda function"
  default     = "kainoscore-app"
}

variable "session_secret" {
  type        = string
  description = "Session secret for the application"
  sensitive   = true
}

variable "auth_config_file_name" {
  type        = string
  description = "Name of the auth config file"
  default     = "auth"
}

variable "core_lambda_alias" {
  type        = string
  description = "Alias For Fabric/Core Lambda"
  default     = "CoreLambda"
}

variable "lambda_runtime" {
  type        = string
  description = "Lambda Runtime "
  default     = "nodejs22.x"
}

variable "lambda_memory" {
  type        = string
  description = "Lambda Memory Size "
  default     = "512"
}