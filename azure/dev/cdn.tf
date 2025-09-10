resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = local.cdn_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = local.api_cdn_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "static_group" {
  name                     = "static-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 60
  }
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "function_group" {
  name                     = "function-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 60
  }
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
  }
}

resource "azurerm_cdn_frontdoor_origin" "static_origin" {
  name                           = "static-origin"
  certificate_name_check_enabled = false
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.static_group.id
  host_name                      = module.static_storage.storage_account_primary_web_host
  origin_host_header             = module.static_storage.storage_account_primary_web_host
  https_port                     = 443
  priority                       = 1
  weight                         = 100
}

resource "azurerm_cdn_frontdoor_origin" "function_origin" {
  name                           = "function-origin"
  certificate_name_check_enabled = false
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.function_group.id
  host_name                      = module.core_function_app.function_app_hostname
  origin_host_header             = module.core_function_app.function_app_hostname
  https_port                     = 443
  priority                       = 1
  weight                         = 100
}


resource "azurerm_cdn_frontdoor_route" "assets_route" {
  name                          = "assets-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.static_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.static_origin.id]
  patterns_to_match             = ["/assets/*"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.static_cache_set.id]
  depends_on = [
    azurerm_cdn_frontdoor_origin.static_origin,
    azurerm_cdn_frontdoor_rule_set.static_cache_set
  ]
}

resource "azurerm_cdn_frontdoor_route" "public_route" {
  name                          = "public-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.static_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.static_origin.id]
  patterns_to_match             = ["/public/*"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.static_cache_set.id]
  depends_on = [
    azurerm_cdn_frontdoor_origin.static_origin,
    azurerm_cdn_frontdoor_rule_set.static_cache_set
  ]
}


resource "azurerm_cdn_frontdoor_route" "root_route" {
  name                          = "root-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.function_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.function_origin.id]
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  depends_on = [
    azurerm_cdn_frontdoor_origin.function_origin,
    azurerm_cdn_frontdoor_origin_group.function_group
  ]
}


resource "azurerm_cdn_frontdoor_rule_set" "static_cache_set" {
  name                     = "staticcacheset"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_rule" "static_cache_rule" {
  name                      = "staticcacherule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.static_cache_set.id
  order                     = 1
  behavior_on_match         = "Continue"
  actions {
    route_configuration_override_action {
      cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.static_group.id
      forwarding_protocol           = "MatchRequest"
      compression_enabled           = true
      cache_behavior                = "OverrideAlways"
      cache_duration                = "1.00:00:00"
      query_string_caching_behavior = "UseQueryString"
    }
  }
  conditions {
    url_path_condition {
      operator         = "BeginsWith"
      negate_condition = false
      match_values     = ["/assets/", "/public/"]
    }
  }
  depends_on = [
    azurerm_cdn_frontdoor_origin.static_origin,
    azurerm_cdn_frontdoor_origin_group.static_group
  ]
}


