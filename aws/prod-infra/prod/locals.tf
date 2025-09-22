locals {
  cloudfront_comment                     = "Core Distribution ${var.env}"
  s3_bucket_kfd_name                     = "kainoscore-kfdfiles-${var.env}"
  s3_bucket_zip_files_name               = "kainoscore-zip-files-${var.env}"
  s3_bucket_static_files_name            = "kainoscore-staticfiles-${var.env}"
  s3_bucket_submitted_form_data_name     = "kainoscore-submitted-form-data-${var.env}"
  s3_bucket_core_audit_logs_name         = "kainoscore-audit-logs-${var.env}"
  dynamodb_core_form_sessions_table_name = "Core_FormSessions_${var.env}"

  tags = {
    Owner       = "Terraform"
    Environment = "${var.env}"
    Project     = "kainoStudio"
    ServiceName = "kainoscore"
    Provider    = "aws"
  }
}
