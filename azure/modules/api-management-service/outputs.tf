output "api_management_id" {
  description = "ID of the API Management service"
  value       = azurerm_api_management.apim.id
}

output "api_management_name" {
  description = "Name of the API Management service"
  value       = azurerm_api_management.apim.name
}

output "api_management_gateway_url" {
  description = "Gateway URL of the API Management service"
  value       = azurerm_api_management.apim.gateway_url
}

output "api_management_gateway_host" {
  description = "Gateway host of the API Management service (for CDN origin)"
  value       = replace(azurerm_api_management.apim.gateway_url, "https://", "")
}

output "api_management_portal_url" {
  description = "Developer portal URL of the API Management service"
  value       = azurerm_api_management.apim.developer_portal_url
}

output "api_management_management_api_url" {
  description = "Management API URL of the API Management service"
  value       = azurerm_api_management.apim.management_api_url
}

output "api_management_scm_url" {
  description = "SCM URL of the API Management service"
  value       = azurerm_api_management.apim.scm_url
}

output "api_management_identity" {
  description = "Managed Identity of the API Management service"
  value = {
    principal_id = azurerm_api_management.apim.identity[0].principal_id
    tenant_id    = azurerm_api_management.apim.identity[0].tenant_id
  }
}
