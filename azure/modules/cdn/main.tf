resource "azurerm_cdn_profile" "main" {
  name                = var.cdn_profile_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.cdn_sku

  tags = var.tags
}

resource "azurerm_cdn_endpoint" "api" {
  name                = var.api_endpoint_name
  profile_name        = azurerm_cdn_profile.main.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin_host_header = var.api_origin_host
  origin_path        = var.api_origin_path

  origin {
    name      = "api-origin"
    host_name = var.api_origin_host
  }

  # Cache rules
  delivery_rule {
    name  = "apicacherule"
    order = 1

    url_path_condition {
      operator     = "BeginsWith"
      match_values = ["/api/"]
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "1.00:00:00"
    }

    modify_response_header_action {
      action = "Append"
      name   = "Cache-Control"
      value  = "public, max-age=86400"
    }
  }

  # CORS
  delivery_rule {
    name  = "corsheaders"
    order = 2

    request_method_condition {
      operator     = "Equal"
      match_values = ["OPTIONS"]
    }

    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Origin"
      value  = var.allowed_origins[0] # Primary origin
    }

    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Methods"
      value  = "GET, POST, PUT, DELETE, OPTIONS"
    }

    modify_response_header_action {
      action = "Append"
      name   = "Access-Control-Allow-Headers"
      value  = "Content-Type, Authorization"
    }
  }

  optimization_type = var.optimization_type

  is_https_allowed = true
  is_http_allowed  = var.allow_http

  querystring_caching_behaviour = var.querystring_caching

  tags = var.tags
}

resource "azurerm_cdn_endpoint" "static" {
  count = var.enable_static_endpoint ? 1 : 0

  name                = var.static_endpoint_name
  profile_name        = azurerm_cdn_profile.main.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin_host_header = var.static_origin_host
  origin_path        = var.static_origin_path

  origin {
    name      = "static-origin"
    host_name = var.static_origin_host
  }

  # Static content cache
  delivery_rule {
    name  = "staticcacherule"
    order = 1

    url_file_extension_condition {
      operator     = "Equal"
      match_values = ["js", "css", "png", "jpg", "jpeg", "gif", "ico", "svg", "woff", "woff2"]
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "365.00:00:00" # 1 year for static assets
    }

    modify_response_header_action {
      action = "Append"
      name   = "Cache-Control"
      value  = "public, max-age=31536000, immutable"
    }
  }

  # HTML files - shorter cache
  delivery_rule {
    name  = "htmlcacherule"
    order = 2

    url_file_extension_condition {
      operator     = "Equal"
      match_values = ["html", "htm"]
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "1.00:00:00" # 1 day for HTML
    }

    modify_response_header_action {
      action = "Append"
      name   = "Cache-Control"
      value  = "public, max-age=86400"
    }
  }

  # Optimize for general web delivery
  optimization_type = var.optimization_type

  # Enable HTTPS
  is_https_allowed = true
  is_http_allowed  = var.allow_http

  # Query string caching
  querystring_caching_behaviour = "IgnoreQueryString"

  tags = var.tags
}

# Custom Domain (optional)
resource "azurerm_cdn_endpoint_custom_domain" "main" {
  count = var.enable_custom_domain && var.custom_domain_name != null ? 1 : 0

  name            = replace(var.custom_domain_name, ".", "-")
  cdn_endpoint_id = azurerm_cdn_endpoint.api.id
  host_name       = var.custom_domain_name

  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = "TLS12"
  }
}
