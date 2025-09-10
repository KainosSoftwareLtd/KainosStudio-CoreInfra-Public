locals {
  s3_bucket_core_audit_logs_name = "kainoscore-audit-logs-${var.env}"
  s3_bucket_pipeline             = "kainoscore-pipeline-bucket"
  tags = {
    Owner       = "Terraform"
    Environment = "${var.env}"
    Project     = "kainoStudio"
    ServiceName = "kainoscore"
    Provider    = "aws"
  }
}
