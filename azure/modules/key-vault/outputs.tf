output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "secret_ids" {
  description = "IDs of the created secrets"
  value       = azurerm_key_vault_secret.secrets[*].id
}

output "key_ids" {
  description = "IDs of the created keys"
  value       = azurerm_key_vault_key.keys[*].id
}

output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.key_vault_pe[0].id : null
}
