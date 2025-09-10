resource "azurerm_log_analytics_workspace" "global" {
  name                = local.log_analytics_name
  location            = azurerm_resource_group.global.location
  resource_group_name = azurerm_resource_group.global.name

  sku               = "PerGB2018"
  retention_in_days = var.log_retention_days

  internet_ingestion_enabled = true
  internet_query_enabled     = true

  tags = local.common_tags
}

resource "azurerm_application_insights" "global" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.global.location
  resource_group_name = azurerm_resource_group.global.name

  workspace_id     = azurerm_log_analytics_workspace.global.id
  application_type = "web"

  retention_in_days = var.log_retention_days

  sampling_percentage = 100

  tags = local.common_tags
}

resource "azurerm_monitor_action_group" "global" {
  name                = "${var.project_name}-global-alerts"
  resource_group_name = azurerm_resource_group.global.name
  short_name          = "kcglobal"

  email_receiver {
    name          = "admin"
    email_address = "devops@kainos.com"
  }

  tags = local.common_tags
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  count = var.enable_diagnostic_settings ? 1 : 0

  name                       = "key-vault-diagnostics"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.global.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage" {
  count = var.enable_diagnostic_settings ? 1 : 0

  name                       = "storage-diagnostics"
  target_resource_id         = azurerm_storage_account.shared.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.global.id

  enabled_metric {
    category = "AllMetrics"
  }
}
