

# Retrieve the current AWS region from the provider configuration
data "aws_region" "current" {}

locals {
  tags = var.tags
}
#checkov:skip=CKV2_AWS_61:Lifecycle not needed
#checkov:skip=CKV2_AWS_62:not needed at this point 
#checkov:skip=CKV_AWS_144:Not required for this project
resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  object_lock_enabled = var.enable_object_lock
  tags                = local.tags
}

# Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status     = var.enable_versioning || var.enable_object_lock || var.enable_mfa_delete ? "Enabled" : "Suspended"
    mfa_delete = var.enable_mfa_delete ? "Enabled" : "Disabled"
  }
}

#Object Lock (if enabled)
resource "aws_s3_bucket_object_lock_configuration" "this" {
  count  = var.enable_object_lock ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock_mode
      days = var.object_lock_retention_days
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle_expiration && var.expiration_days > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Logging
resource "aws_s3_bucket_logging" "this" {
  count = var.enable_logging ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging_target_bucket
  target_prefix = var.logging_target_prefix != null ? var.logging_target_prefix : "${var.environment}-bucket-logs/"
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.enable_encryption && var.kms_key_id != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.enable_public_access_block ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload Static Files
resource "null_resource" "upload_files" {
  count = var.upload_files ? 1 : 0

  provisioner "local-exec" {
    command = "aws s3 sync ${var.files_path} s3://${aws_s3_bucket.this.bucket}/ --delete --region ${data.aws_region.current.name}"
  }

  depends_on = [aws_s3_bucket.this]
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.s3_object_ownership
  }
}

# Cors configuration
resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.enable_cors ? 1 : 0

  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
  }
}