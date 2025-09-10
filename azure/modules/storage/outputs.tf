output "storage_account_id" {
  description = "The resource ID of the storage account."
  value       = azurerm_storage_account.storage.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_primary_access_key" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the storage account"
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "storage_account_primary_web_host" {
  description = "Primary static website host of the storage account (for CDN origin)"
  value       = azurerm_storage_account.storage.primary_web_host
}

output "container_names" {
  description = "Names of the created containers"
  value       = azurerm_storage_container.container[*].name
}

output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.storage_pe[0].id : null
}
