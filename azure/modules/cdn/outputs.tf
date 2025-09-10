output "cdn_profile_id" {
  description = "ID of the CDN profile"
  value       = azurerm_cdn_profile.main.id
}

output "cdn_profile_name" {
  description = "Name of the CDN profile"
  value       = azurerm_cdn_profile.main.name
}

output "api_endpoint_id" {
  description = "ID of the API CDN endpoint"
  value       = azurerm_cdn_endpoint.api.id
}

output "api_endpoint_fqdn" {
  description = "FQDN of the API CDN endpoint"
  value       = azurerm_cdn_endpoint.api.fqdn
}

output "api_endpoint_url" {
  description = "URL of the API CDN endpoint"
  value       = "https://${azurerm_cdn_endpoint.api.fqdn}"
}

output "static_endpoint_id" {
  description = "ID of the static content CDN endpoint"
  value       = var.enable_static_endpoint ? azurerm_cdn_endpoint.static[0].id : null
}

output "static_endpoint_fqdn" {
  description = "FQDN of the static content CDN endpoint"
  value       = var.enable_static_endpoint ? azurerm_cdn_endpoint.static[0].fqdn : null
}

output "static_endpoint_url" {
  description = "URL of the static content CDN endpoint"
  value       = var.enable_static_endpoint ? "https://${azurerm_cdn_endpoint.static[0].fqdn}" : null
}

output "custom_domain_fqdn" {
  description = "FQDN of the custom domain (if configured)"
  value       = var.enable_custom_domain && var.custom_domain_name != null ? azurerm_cdn_endpoint_custom_domain.main[0].host_name : null
}

output "cdn_url" {
  description = "Primary CDN URL (custom domain if enabled, otherwise Azure CDN domain)"
  value       = var.enable_custom_domain && var.custom_domain_name != null ? "https://${azurerm_cdn_endpoint_custom_domain.main[0].host_name}" : "https://${azurerm_cdn_endpoint.api.fqdn}"
}

output "azure_cdn_url" {
  description = "Azure-provided CDN URL (always available for testing)"
  value       = "https://${azurerm_cdn_endpoint.api.fqdn}"
}
