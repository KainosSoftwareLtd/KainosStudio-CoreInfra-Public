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
  default     = "global"
}

variable "lambda_role_name" {
  type        = string
  description = "Role Name for Lambdas"
  default     = "Core-Lambda-Role"
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