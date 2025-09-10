output "cosmosdb_account_id" {
  description = "The resource ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.cosmos.id
}
output "cosmos_account_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.id
}

output "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.name
}

output "cosmos_account_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.endpoint
}

output "cosmos_account_primary_key" {
  description = "Primary key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.primary_key
  sensitive   = true
}

output "cosmos_account_connection_string" {
  description = "Primary connection string of the Cosmos DB account"
  value       = "AccountEndpoint=${azurerm_cosmosdb_account.cosmos.endpoint};AccountKey=${azurerm_cosmosdb_account.cosmos.primary_key};"
  sensitive   = true
}

output "cosmos_account_secondary_key" {
  description = "Secondary key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmos.secondary_key
  sensitive   = true
}

output "database_id" {
  description = "ID of the database"
  value       = azurerm_cosmosdb_sql_database.database.id
}

output "database_name" {
  description = "Name of the database"
  value       = azurerm_cosmosdb_sql_database.database.name
}

output "container_ids" {
  description = "IDs of the containers"
  value       = azurerm_cosmosdb_sql_container.container[*].id
}

output "container_names" {
  description = "Names of the containers"
  value       = azurerm_cosmosdb_sql_container.container[*].name
}

output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.cosmos_pe[0].id : null
}
