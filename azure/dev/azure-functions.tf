resource "azurerm_service_plan" "shared" {
  name                = local.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.function_app_sku
  tags                = local.tags
}

module "core_function_app" {
  source                     = "../modules/function-app"
  function_app_name          = local.core_function_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku_name                   = var.function_app_sku
  use_external_service_plan  = true
  service_plan_id            = azurerm_service_plan.shared.id
  storage_account_name       = module.zip_storage.storage_account_name
  storage_account_access_key = module.zip_storage.storage_account_primary_access_key
  storage_account_id         = module.zip_storage.storage_account_id
  cosmosdb_account_id        = module.cosmos_db.cosmosdb_account_id
  node_version               = "22"
  allowed_origins            = var.allowed_origins
  logs_retention_days        = var.log_retention_days
  app_settings = {
    CLOUD_PROVIDER                         = "azure"
    AZURE_STORAGE_ACCOUNT                  = "kainoscorekfddev"
    AZURE_STORAGE_CONTAINER                = "kfd-files"
    AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES   = "kainoscoreformdatadev"
    AZURE_STORAGE_CONTAINER_FOR_FORM_FILES = "submitted-forms"
    AZURE_COSMOS_ENDPOINT                  = "https://kainoscore-cosmosdb-dev.documents.azure.com:443/"
    AZURE_COSMOS_DATABASE                  = "KainoscoreDB"
    FORM_SESSION_TABLE_NAME                = "FormSessions"
    SESSION_SECRET                         = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.global.name};SecretName=session-secret)"
    AUTH_CONFIG_FILE_NAME                  = var.auth_config_file_name
    NODE_ENV                               = "production"
    ALLOWED_ORIGIN                         = "https://${azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name}"
  }
  key_vault_id = data.azurerm_key_vault.global.id
  tags         = local.tags
}

module "kfd_api_function_app" {
  source                     = "../modules/function-app"
  function_app_name          = local.kfd_api_function_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku_name                   = var.function_app_sku
  use_external_service_plan  = true
  service_plan_id            = azurerm_service_plan.shared.id
  storage_account_name       = module.zip_storage.storage_account_name
  storage_account_access_key = module.zip_storage.storage_account_primary_access_key
  storage_account_id         = module.zip_storage.storage_account_id
  cosmosdb_account_id        = module.cosmos_db.cosmosdb_account_id
  node_version               = "22"
  allowed_origins            = var.allowed_origins
  logs_retention_days        = var.log_retention_days
  app_settings = {
    CLOUD_PROVIDER          = "azure"
    AZURE_STORAGE_ACCOUNT   = "kainoscorekfddev"
    AZURE_STORAGE_CONTAINER = "kfd-files"
    NODE_ENV                = "production"
  }
  key_vault_id = data.azurerm_key_vault.global.id
  tags         = local.tags
}