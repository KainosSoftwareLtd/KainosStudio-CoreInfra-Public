locals {
  account_id                     = "696793786584"
  s3_bucket_core_audit_logs_name = "kainoscore-audit-logs-${var.env}"
  s3_bucket_global               = "kainoscore-global-bucket"
  tags = {
    Owner       = "Terraform"
    Environment = "${var.env}"
    Project     = "kainoStudio"
    ServiceName = "kainoscore"
    Provider    = "aws"
  }
}
