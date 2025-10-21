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
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:s3:::${local.s3_bucket_kfd_name}",
        "arn:aws:s3:::${local.s3_bucket_static_files_name}",
        "arn:aws:s3:::${local.s3_bucket_submitted_form_data_name}",
        "arn:aws:s3:::${local.s3_bucket_zip_files_name}"
      ]
    }
  }
  statement {
    sid    = "AllowS3LoggingGetBucketAcl"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_core_audit_logs_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}