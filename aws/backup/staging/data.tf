data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

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

data "aws_vpc" "prod_vpc" {
  id = var.prod_vpc_id
}

data "aws_subnet" "private_subnets_prod" {
  vpc_id = data.aws_vpc.prod_vpc.id
  id     = var.prod_private_subnet_id

}

data "aws_security_group" "prod-codebuild_sg" {
  id = var.prod_codebuild_security_group_id
}

data "aws_iam_role" "gha_codebuild_service_role" {
  name = var.gha_codebuild_service_role_name

}

data "aws_iam_role" "api_gateway_logging_role" {
  name = var.api_gateway_logging_role_name
}

data "aws_wafv2_web_acl" "cloudfront_acl" {
  provider = aws.useast1
  name     = var.waf_acl_name
  scope    = "CLOUDFRONT"
}