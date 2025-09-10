

# # AWS WAFv2 WebACL for CloudFront with Only AWS Managed Rules
# resource "aws_wafv2_web_acl" "cloudfront_acl" {
#   provider    = aws.east
#   name        = "cloudfront-waf-${var.env}"
#   description = "WAF ACL for CloudFront in ${var.env} environment"
#   scope       = "CLOUDFRONT" # Must be CLOUDFRONT for CloudFront

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "cloudfront-waf-${var.env}"
#     sampled_requests_enabled   = true
#   }

#   # AWS Managed Common Rule Set
#   rule {
#     name     = "AWSManagedRulesCommonRuleSet"
#     priority = 1
#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }
#     override_action {
#       none {}
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   # AWS Managed SQL Injection Rule Set
#   rule {
#     name     = "AWSManagedRulesSQLiRuleSet"
#     priority = 2
#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"
#       }
#     }
#     override_action {
#       none {}
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesSQLiRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   # AWS Managed Known Bad Inputs Rule Set
#   rule {
#     name     = "AWSManagedRulesKnownBadInputsRuleSet"
#     priority = 3
#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"
#       }
#     }
#     override_action {
#       none {}
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   tags = local.tags
# }
