module "kfd_s3_bucket" {
  source                      = "../modules/s3"
  bucket_name                 = local.s3_bucket_kfd_name
  tags                        = local.tags
  enable_versioning           = true
  enable_logging              = true
  logging_target_bucket       = module.s3_core_audit_logs.bucket_id
  logging_target_prefix       = "s3-bucket-kfd-files/"
  environment                 = var.env
  enable_encryption           = true
  kms_key_id                  = data.aws_kms_alias.s3.target_key_arn
  enable_public_access_block  = true
  upload_files                = true
  files_path                  = "./kfd/"
  enable_mfa_delete           = false
  enable_object_lock          = false
  object_lock_mode            = "GOVERNANCE"
  object_lock_retention_days  = 30
  enable_lifecycle_expiration = false
  expiration_days             = 30
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}


module "static_s3_bucket" {
  source                             = "../modules/s3"
  bucket_name                        = local.s3_bucket_static_files_name
  tags                               = local.tags
  enable_versioning                  = true
  enable_logging                     = true
  logging_target_bucket              = module.s3_core_audit_logs.bucket_id
  logging_target_prefix              = "s3-bucket-static-files/"
  environment                        = var.env
  enable_encryption                  = true
  kms_key_id                         = data.aws_kms_alias.s3.target_key_arn
  enable_public_access_block         = true
  upload_files                       = true
  files_path                         = "./static-files/"
  enable_mfa_delete                  = false
  enable_object_lock                 = false
  object_lock_mode                   = "GOVERNANCE"
  object_lock_retention_days         = 30
  enable_lifecycle_expiration        = false
  expiration_days                    = 30
  additional_bucket_policy_documents = [data.aws_iam_policy_document.static_files_bucket_policy.json]
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}


module "submitted_form_data" {
  source                      = "../modules/s3"
  bucket_name                 = local.s3_bucket_submitted_form_data_name
  tags                        = local.tags
  enable_versioning           = true
  enable_logging              = true
  logging_target_bucket       = module.s3_core_audit_logs.bucket_id
  logging_target_prefix       = "s3-bucket-submitted-form-data/"
  environment                 = var.env
  enable_encryption           = true
  kms_key_id                  = data.aws_kms_alias.s3.target_key_arn
  enable_public_access_block  = true
  enable_mfa_delete           = false
  enable_object_lock          = false
  object_lock_mode            = "GOVERNANCE"
  object_lock_retention_days  = 30
  enable_lifecycle_expiration = false
  expiration_days             = 30
  enable_cors                 = true
  cors_allowed_headers        = ["*"]
  cors_allowed_methods        = ["POST"]
  cors_allowed_origins        = ["https://${var.domain}"]
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}

module "s3_core_zip_files" {
  source                      = "../modules/s3"
  bucket_name                 = local.s3_bucket_zip_files_name
  tags                        = local.tags
  enable_versioning           = true
  enable_logging              = true
  logging_target_bucket       = module.s3_core_audit_logs.bucket_id
  logging_target_prefix       = "s3-kainoscore-zip-files/"
  environment                 = var.env
  enable_encryption           = true
  kms_key_id                  = data.aws_kms_alias.s3.target_key_arn
  enable_public_access_block  = true
  enable_mfa_delete           = false
  enable_object_lock          = false
  object_lock_mode            = "GOVERNANCE"
  object_lock_retention_days  = 30
  enable_lifecycle_expiration = false
  expiration_days             = 30
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}

#The core audit logs bucket must be created before the others because they reference it.
module "s3_core_audit_logs" {
  source                             = "../modules/s3"
  bucket_name                        = local.s3_bucket_core_audit_logs_name
  tags                               = local.tags
  enable_versioning                  = true
  enable_logging                     = false
  logging_target_bucket              = null
  logging_target_prefix              = null
  environment                        = var.env
  enable_encryption                  = true
  kms_key_id                         = data.aws_kms_alias.s3.target_key_arn
  enable_public_access_block         = true
  enable_mfa_delete                  = false
  enable_object_lock                 = true
  object_lock_mode                   = "GOVERNANCE"
  object_lock_retention_days         = 30
  enable_lifecycle_expiration        = true
  expiration_days                    = 30
  additional_bucket_policy_documents = [data.aws_iam_policy_document.s3_core_audit_logs_policy.json]
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}

resource "aws_s3_bucket_acl" "cloudfront_acl" {
  bucket = local.s3_bucket_core_audit_logs_name
  acl    = "log-delivery-write"
}