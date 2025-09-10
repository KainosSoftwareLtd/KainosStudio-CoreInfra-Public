# Assign custom role to Function App managed identity
resource "azurerm_role_assignment" "dev_function_app_custom_role" {
  principal_id       = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_id = azurerm_role_definition.kainoscore_function_app.role_definition_resource_id
  scope              = data.terraform_remote_state.dev.outputs.resource_group_id
  description        = "Assign custom KainosCore Function App Role to Function App managed identity in dev"
}

# Assign custom role to KFD API Function App managed identity
resource "azurerm_role_assignment" "dev_kfd_api_function_app_custom_role" {
  principal_id       = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_id = azurerm_role_definition.kainoscore_function_app.role_definition_resource_id
  scope              = data.terraform_remote_state.dev.outputs.resource_group_id
  description        = "Assign custom KainosCore Function App Role to KFD API Function App managed identity in dev"
}

# Function App access to KFD storage account
resource "azurerm_role_assignment" "function_app_kfd_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.kfd_storage_account_id
  description          = "Function App access to KFD storage account"
}

# KFD API Function App access to KFD storage account
resource "azurerm_role_assignment" "kfd_api_function_app_kfd_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.kfd_storage_account_id
  description          = "KFD API Function App access to KFD storage account"
}

# Function App access to Form Data storage account
resource "azurerm_role_assignment" "function_app_form_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.form_data_storage_account_id
  description          = "Function App access to form data storage account"
}

# KFD API Function App access to Form Data storage account
resource "azurerm_role_assignment" "kfd_api_function_app_form_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.form_data_storage_account_id
  description          = "KFD API Function App access to form data storage account"
}

# Function App access to Static storage account
resource "azurerm_role_assignment" "function_app_static_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.static_storage_account_id
  description          = "Function App access to static storage account"
}

# KFD API Function App access to Static storage account
resource "azurerm_role_assignment" "kfd_api_function_app_static_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.static_storage_account_id
  description          = "KFD API Function App access to static storage account"
}

# Function App access to Zip storage account
resource "azurerm_role_assignment" "function_app_zip_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.zip_storage_account_id
  description          = "Function App access to zip storage account"
}

# KFD API Function App access to Zip storage account
resource "azurerm_role_assignment" "kfd_api_function_app_zip_storage" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.terraform_remote_state.dev.outputs.zip_storage_account_id
  description          = "KFD API Function App access to zip storage account"
}

# Function App access to Cosmos DB - Reader Role
resource "azurerm_role_assignment" "function_app_cosmos_reader" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Cosmos DB Account Reader Role"
  scope                = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
  description          = "Function App read access to Cosmos DB account metadata"
}

# KFD API Function App access to Cosmos DB - Reader Role
resource "azurerm_role_assignment" "kfd_api_function_app_cosmos_reader" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Cosmos DB Account Reader Role"
  scope                = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
  description          = "KFD API Function App read access to Cosmos DB account metadata"
}

# Function App access to Cosmos DB - Contributor Role
resource "azurerm_role_assignment" "function_app_cosmos_contributor" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "DocumentDB Account Contributor"
  scope                = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
  description          = "Function App full management access to Cosmos DB account"
}

# KFD API Function App access to Cosmos DB - Contributor Role
resource "azurerm_role_assignment" "kfd_api_function_app_cosmos_contributor" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "DocumentDB Account Contributor"
  scope                = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
  description          = "KFD API Function App full management access to Cosmos DB account"
}

# Function App access to Cosmos DB - SQL Data Contributor
resource "azurerm_cosmosdb_sql_role_assignment" "function_app_cosmos_data_contributor" {
  resource_group_name = data.terraform_remote_state.dev.outputs.resource_group_name
  account_name        = data.terraform_remote_state.dev.outputs.cosmosdb_account_name
  role_definition_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.terraform_remote_state.dev.outputs.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${data.terraform_remote_state.dev.outputs.cosmosdb_account_name}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  scope               = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
}

# KFD API Function App access to Cosmos DB - SQL Data Contributor
resource "azurerm_cosmosdb_sql_role_assignment" "kfd_api_function_app_cosmos_data_contributor" {
  resource_group_name = data.terraform_remote_state.dev.outputs.resource_group_name
  account_name        = data.terraform_remote_state.dev.outputs.cosmosdb_account_name
  role_definition_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.terraform_remote_state.dev.outputs.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${data.terraform_remote_state.dev.outputs.cosmosdb_account_name}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  scope               = data.terraform_remote_state.dev.outputs.cosmosdb_account_id
}

# Function App access to Key Vault
resource "azurerm_role_assignment" "function_app_key_vault" {
  principal_id         = data.terraform_remote_state.dev.outputs.core_function_app_principal_id
  role_definition_name = "Key Vault Secrets User"
  scope                = data.terraform_remote_state.global.outputs.key_vault_id
  description          = "Function App access to Key Vault secrets"
}

# KFD API Function App access to Key Vault
resource "azurerm_role_assignment" "kfd_api_function_app_key_vault" {
  principal_id         = data.terraform_remote_state.dev.outputs.kfd_api_function_app_principal_id
  role_definition_name = "Key Vault Secrets User"
  scope                = data.terraform_remote_state.global.outputs.key_vault_id
  description          = "KFD API Function App access to Key Vault secrets"
}
## Data source for dev remote state
data "terraform_remote_state" "dev" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "kainoscorestate2025"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}




# Role assignments for GitHub Actions Service Principal

# Subscription-level Contributor for GitHub Actions
resource "azurerm_role_assignment" "github_actions_subscription" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = data.terraform_remote_state.global.outputs.github_actions_service_principal_id

  description = "GitHub Actions Contributor access for CI/CD deployments"
}

# Key Vault access for GitHub Actions
resource "azurerm_role_assignment" "github_actions_key_vault" {
  scope                = data.terraform_remote_state.global.outputs.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.terraform_remote_state.global.outputs.github_actions_service_principal_id

  description = "GitHub Actions Key Vault access for secret management"
}

# Storage account access for GitHub Actions
resource "azurerm_role_assignment" "github_actions_storage" {
  scope                = data.terraform_remote_state.global.outputs.shared_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.terraform_remote_state.global.outputs.github_actions_service_principal_id

  description = "GitHub Actions storage access for deployment artifacts"
}

# Log Analytics access for GitHub Actions
resource "azurerm_role_assignment" "github_actions_monitoring" {
  scope                = data.terraform_remote_state.global.outputs.log_analytics_workspace_id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = data.terraform_remote_state.global.outputs.github_actions_service_principal_id

  description = "GitHub Actions monitoring access for deployment logging"
}







