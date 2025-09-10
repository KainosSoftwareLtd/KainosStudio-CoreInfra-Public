output "log_analytics_workspace_name" {
  description = "Name of the global Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.global.name
}
output "resource_group_names" {
  description = "Names of environment resource groups"
  value       = { for k, v in azurerm_resource_group.environments : k => v.name }
}

output "global_resource_group_name" {
  description = "Name of the global resource group"
  value       = azurerm_resource_group.global.name
}

output "terraform_resource_group_name" {
  description = "Name of the Terraform resource group"
  value       = azurerm_resource_group.terraform.name
}


output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "application_insights_id" {
  description = "ID of the global Application Insights"
  value       = azurerm_application_insights.global.id
}

output "application_insights_name" {
  description = "Name of the global Application Insights"
  value       = azurerm_application_insights.global.name
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.global.connection_string
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.global.instrumentation_key
  sensitive   = true
}

output "shared_storage_account_name" {
  description = "Name of the shared storage account"
  value       = azurerm_storage_account.shared.name
}

output "shared_storage_account_id" {
  description = "ID of the shared storage account"
  value       = azurerm_storage_account.shared.id
}

output "github_actions_service_principal_id" {
  description = "Object ID of the GitHub Actions service principal"
  value       = azuread_service_principal.github_actions.object_id
}

output "github_actions_application_id" {
  description = "Application ID of the GitHub Actions service principal"
  value       = azuread_application.github_actions.client_id
}

output "location" {
  description = "Azure region location"
  value       = var.location
}

output "common_tags" {
  description = "Common tags for all resources"
  value       = local.common_tags
}

output "environment_tags" {
  description = "Environment-specific tags"
  value       = local.environment_tags
}
