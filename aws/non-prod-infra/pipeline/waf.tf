# CloudWatch Log Group for WAF logs
resource "aws_cloudwatch_log_group" "waf_log_group" {
  provider          = aws.useast1
  name              = "aws-waf-logs-kcwafacl"
  kms_key_id        = aws_kms_key.waf_logs_key.arn
  retention_in_days = 30
  tags              = local.tags
}

# CloudWatch Log Resource Policy for WAF
resource "aws_cloudwatch_log_resource_policy" "waf_log_policy" {
  provider        = aws.useast1
  policy_name     = "waf-log-policy"
  policy_document = data.aws_iam_policy_document.waf_cloudwatch_policy.json
}

data "aws_iam_policy_document" "waf_cloudwatch_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.waf_log_group.arn}:*"]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:global/webacl/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "cloudfront_acl_logging" {
  provider                = aws.useast1
  resource_arn            = aws_wafv2_web_acl.cloudfront_acl.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]

  # Redact sensitive headers from logs
  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }

  redacted_fields {
    single_header {
      name = "x-api-key"
    }
  }

  depends_on = [aws_cloudwatch_log_resource_policy.waf_log_policy]
}

resource "aws_wafv2_web_acl" "cloudfront_acl" {
  provider    = aws.useast1
  name        = "cloudfront-waf-acl"
  description = "WAF ACL for Kainos Studio Edge CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CloudFrontWAFACL"
    sampled_requests_enabled   = true
  }

  # Block all requests NOT coming from Canada, USA, Great Britain, or Poland
  rule {
    name     = "BlockNonAllowedCountries"
    priority = 0
    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = ["CA", "US", "GB", "PL"]
          }
        }
      }
    }
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockNonAllowedCountries"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Known Bad Inputs Rule Set
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Amazon IP Reputation List
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 4
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Bot Control Rule Set
  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 5
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
  tags = local.tags
}
