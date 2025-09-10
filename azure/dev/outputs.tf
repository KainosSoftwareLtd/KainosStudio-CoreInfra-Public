output "resource_group_id" {
  description = "Resource ID of the resource group"
  value       = data.azurerm_resource_group.main.id
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = data.azurerm_log_analytics_workspace.global.id
}

output "core_function_app_principal_id" {
  description = "Principal ID of the system-assigned managed identity for the Core Function App"
  value       = module.core_function_app.function_app_identity.principal_id
}

output "kfd_api_function_app_principal_id" {
  description = "Principal ID of the system-assigned managed identity for the KFD API Function App"
  value       = module.kfd_api_function_app.function_app_identity.principal_id
}

output "kfd_storage_account_id" {
  description = "Resource ID of the KFD Storage Account"
  value       = module.kfd_storage.storage_account_id
}

output "static_storage_account_id" {
  description = "Resource ID of the Static Storage Account"
  value       = module.static_storage.storage_account_id
}

output "form_data_storage_account_id" {
  description = "Resource ID of the Form Data Storage Account"
  value       = module.form_data_storage.storage_account_id
}

output "zip_storage_account_id" {
  description = "Resource ID of the Zip Storage Account"
  value       = module.zip_storage.storage_account_id
}

output "cosmosdb_account_id" {
  description = "Resource ID of the Cosmos DB Account"
  value       = module.cosmos_db.cosmosdb_account_id
}

output "cosmosdb_account_name" {
  description = "Name of the Cosmos DB Account"
  value       = module.cosmos_db.cosmos_account_name
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = data.azurerm_key_vault.global.id
}
output "resource_group_name" {
  description = "Resource group name"
  value       = var.resource_group_name
}

output "core_function_app_url" {
  description = "Core Function App URL"
  value       = module.core_function_app.function_app_url
}

output "kfd_storage_account_name" {
  description = "KFD Storage Account name"
  value       = module.kfd_storage.storage_account_name
}

output "static_storage_account_name" {
  description = "Static Storage Account name"
  value       = module.static_storage.storage_account_name
}

output "cosmos_db_endpoint" {
  description = "Cosmos DB endpoint"
  value       = module.cosmos_db.cosmos_account_endpoint
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = data.azurerm_key_vault.global.vault_uri
}


output "cdn_profile_name" {
  description = "CDN Profile name"
  value       = azurerm_cdn_frontdoor_profile.fd_profile.name
}

output "api_cdn_url" {
  description = "Primary API CDN URL"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "api_cdn_fqdn" {
  description = "API CDN endpoint FQDN"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "static_cdn_url" {
  description = "Static content CDN endpoint URL"
  value       = module.static_storage.storage_account_primary_web_host
}

