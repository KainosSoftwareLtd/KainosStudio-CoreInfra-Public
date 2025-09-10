terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

locals {
  run_from_package_value = null
}

resource "azurerm_service_plan" "function_app_plan" {
  count               = var.use_external_service_plan ? 0 : 1
  name                = "${var.function_app_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_application_insights" "function_app_insights" {
  count               = var.global_application_insights_key == null ? 1 : 0
  name                = "${var.function_app_name}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "Node.JS"
  retention_in_days   = var.logs_retention_days

  tags = var.tags
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = var.use_external_service_plan ? var.service_plan_id : azurerm_service_plan.function_app_plan[0].id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only                 = true

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    application_stack {
      node_version = var.node_version
    }

    cors {
      allowed_origins     = var.allowed_origins
      support_credentials = true
    }

    app_service_logs {
      disk_quota_mb         = 35
      retention_period_days = var.logs_retention_days
    }
  }

  app_settings = merge({
    FUNCTIONS_WORKER_RUNTIME              = "node"
    WEBSITE_NODE_DEFAULT_VERSION          = "~22"
    APPINSIGHTS_INSTRUMENTATIONKEY        = var.global_application_insights_key != null ? var.global_application_insights_key : azurerm_application_insights.function_app_insights[0].instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.global_application_insights_connection_string != null ? var.global_application_insights_connection_string : azurerm_application_insights.function_app_insights[0].connection_string

    SCM_DO_BUILD_DURING_DEPLOYMENT  = "true"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true"
  }, var.app_settings)

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["SCM_DO_BUILD_DURING_DEPLOYMENT"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
      app_settings["WEBSITE_CONTENTAZUREFILECONNECTIONSTRING"],
      app_settings["WEBSITE_CONTENTSHARE"],
      zip_deploy_file,
    ]
  }
}

locals {
  function_app_effective_run_from_package = "(managed-by-cicd)"
}
