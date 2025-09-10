# Static Files Bucket Policy
# Allows CloudFront to access static files.
data "aws_iam_policy_document" "static_files_bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.s3_bucket_static_files_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.distribution.arn}"]
    }
  }
}

#Audit logs bucket policy
#Allows cloudFront and buckets to write logs into this bucket
data "aws_iam_policy_document" "s3_core_audit_logs_policy" {
  statement {
    sid    = "AllowCloudfrontLoggingDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.s3_bucket_core_audit_logs_name}/cloudfront-logs/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.distribution.arn}"]
    }
  }
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