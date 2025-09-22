resource "aws_ssm_parameter" "lambda_core_name" {
  name  = "/lambda/kccorename"
  type  = "String"
  value = "kainoscore-app"
}

resource "aws_ssm_parameter" "lambda_core_zip_file" {
  name  = "/lambda/corezipfile"
  type  = "String"
  value = "kainoscore-code.zip"
}

resource "aws_ssm_parameter" "lambda_kfd_api_name" {
  name  = "/lambda/kckfdapiname"
  type  = "String"
  value = "kainoscore-kfd-api"
}

resource "aws_ssm_parameter" "lambda_kfd_api_zip_file" {
  name  = "/lambda/kckfdapizipfile"
  type  = "String"
  value = "kfd-api.zip"
}

resource "aws_ssm_parameter" "s3_app_kfd_files" {
  name  = "/s3/kcappkfdfiles"
  type  = "String"
  value = "kainoscore-kfd-files"
}

resource "aws_ssm_parameter" "s3_app_static_files" {
  name  = "/s3/kcappstaticfiles"
  type  = "String"
  value = "kainoscore-staticfiles"
}

resource "aws_ssm_parameter" "s3_app_zip_files" {
  name  = "/s3/kcappzipfiles"
  type  = "String"
  value = "kainoscore-zip-files"
}
