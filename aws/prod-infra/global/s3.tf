module "core_global_bucket" {
  source                      = "../../modules/s3"
  bucket_name                 = local.s3_bucket_global
  tags                        = local.tags
  enable_versioning           = true
  enable_logging              = true
  logging_target_bucket       = module.s3_core_audit_logs.bucket_id
  logging_target_prefix       = "core_global_bucket/"
  environment                 = var.env
  enable_encryption           = true
  kms_key_id                  = aws_kms_key.s3_key.arn
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

resource "aws_s3_bucket_ownership_controls" "core_global_bucket_ownership" {
  bucket = module.core_global_bucket.bucket_id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#The core audit logs bucket must be created before the others because they reference it.
module "s3_core_audit_logs" {
  source                             = "../../modules/s3"
  bucket_name                        = local.s3_bucket_core_audit_logs_name
  tags                               = local.tags
  enable_versioning                  = true
  enable_logging                     = false
  logging_target_bucket              = null
  logging_target_prefix              = null
  environment                        = var.env
  enable_encryption                  = true
  kms_key_id                         = aws_kms_key.s3_key.arn
  enable_public_access_block         = true
  enable_mfa_delete                  = false
  enable_object_lock                 = false
  object_lock_mode                   = "GOVERNANCE"
  object_lock_retention_days         = 30
  enable_lifecycle_expiration        = true
  expiration_days                    = 30
  additional_bucket_policy_documents = [data.aws_iam_policy_document.s3_core_audit_logs_policy.json]
  # checkov:CKV2_AWS_62: Not required for this bucket
  # checkov:CKV2_AWS_61: Not required for this bucket
  # checkov:CKV_AWS_144: Not required for this project
}


resource "aws_s3_bucket_ownership_controls" "core_audit_logs_ownership" {
  bucket = module.s3_core_audit_logs.bucket_id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}