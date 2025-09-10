# module "advanced_s3_bucket" {
#   source = "../" # Adjust the path based on your directory structure

#   bucket_name                = "my-advanced-bucket"
#   tags                       = { Environment = "production", Owner = "DevOps" }
#   enable_versioning          = true
#   enable_logging             = true
#   logging_target_bucket      = "my-log-bucket"
#   logging_target_prefix      = "prod-advanced-logs/"
#   environment                = "prod"
#   enable_encryption          = true
#   kms_key_id                 = data.aws_kms_key.s3_key.arn
#   enable_public_access_block = true
#   upload_files               = true
#   files_path                 = "./static-files/"
# }

# data "aws_kms_key" "s3_key" {
#   alias = "alias/my-s3-key"
# }
