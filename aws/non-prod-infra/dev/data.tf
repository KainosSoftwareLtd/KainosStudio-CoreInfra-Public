# Provides details such as the account ID, ARN, and user information
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


# # Retrieves Logging S3 bucket where s3, cloudfront logs are stored
# data "aws_s3_bucket" "core_logs" {
#   bucket = "kainoscore-audit-bucket"
# }

# Retrieve KMS Key via Alias
# data "aws_kms_key" "s3_kms" {
#   key_id = "arn:aws:kms:us-east-1:637423456632:key/72cdc7af-c064-4dc8-aaf8-119df89886f5"
# }
data "aws_kms_alias" "s3" {
  name = var.kms_s3_alias
}

data "aws_kms_alias" "sns" {
  name = var.kms_sns_topic_alias
}

data "aws_kms_alias" "cw" {
  name = var.kms_cw_alias
}

# Data Block To Retreive Dev VPC and Subnets for Codebuild to Build Dev Builds

data "aws_vpc" "dev_vpc" {
  id = var.dev_vpc_id
}


# Private Subnets for Dev VPC
data "aws_subnet" "private_subnets_dev" {
  vpc_id = data.aws_vpc.dev_vpc.id
  id     = var.dev_private_subnet_id

}

# Security Group for Dev Environment
data "aws_security_group" "dev-codebuild_sg" {
  id = var.dev_codebuild_security_group_id
}

data "aws_iam_role" "gha_codebuild_service_role" {
  name = var.gha_codebuild_service_role_name

}

data "aws_wafv2_web_acl" "cloudfront_acl" {
  provider = aws.useast1
  name     = var.waf_acl_name
  scope    = "CLOUDFRONT"
}