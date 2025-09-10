data "aws_iam_policy_document" "s3_core_audit_logs_policy" {
  statement {
    sid    = "AllowS3LoggingDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_core_audit_logs_name}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}