resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.cloudfront_access_control_name}${var.env}"
  description                       = "Core S3 Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "s3_cache_policy" {
  name    = "${var.cloudfront_s3_policy_name}${var.env}"
  comment = "Core S3 Cache Policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    query_strings_config {
      query_string_behavior = "all"
    }
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }

  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0
}

resource "aws_cloudfront_distribution" "distribution" {
  # checkov:skip=CKV2_AWS_32:: Not required for our project
  # checkov:skip=CKV_AWS_68: This will be fixed in Prod, this is a dev environment and we do not want to Pay for the WAF
  # checkov:skip=CKV2_AWS_42 This will be fixed with SSL intergration
  # checkov:skip=CKV_AWS_174: This will be fixed with SSL intergration
  # checkov:skip=CKV_AWS_305: Default Root Object Not required
  # checkov:skip=CKV_AWS_310: Not required for our project
  # checkov:skip=CKV2_AWS_47: This will be fixed in Prod, this is a dev environment and we do not want to Pay for the WAF

  comment    = "Core Distribution ${var.env}"
  enabled    = true
  aliases    = [var.domain]
  web_acl_id = data.aws_wafv2_web_acl.cloudfront_acl.arn

  # this is supposed to be either we use a certificate or we dont 
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  origin {
    origin_id   = "ApiGatewayOrigin"
    domain_name = "${aws_api_gateway_rest_api.core_api.id}.execute-api.${var.region}.amazonaws.com"
    origin_path = var.cloudfront_stage
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    origin_id                = "S3Origin"
    domain_name              = module.static_s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "ApiGatewayOrigin"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"


    # CachePolicyId and OriginRequestPolicyId are global managed policies in AWS
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  # Additional behaviors
  ordered_cache_behavior {
    path_pattern           = "/assets/*"
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = aws_cloudfront_cache_policy.s3_cache_policy.id
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
  }

  ordered_cache_behavior {
    path_pattern           = "/public/*"
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = aws_cloudfront_cache_policy.s3_cache_policy.id
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "PL"]
    }
  }

  logging_config {
    bucket          = module.s3_core_audit_logs.bucket_domain_name
    prefix          = "cloudfront-logs/"
    include_cookies = false
  }

  default_root_object = ""
  price_class         = "PriceClass_100"

  tags = local.tags
}


output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "cloudfront_access_control_id" {
  value = aws_cloudfront_origin_access_control.oac.id
}

output "cloudfront_s3_cache_policy_id" {
  value = aws_cloudfront_cache_policy.s3_cache_policy.id
}



