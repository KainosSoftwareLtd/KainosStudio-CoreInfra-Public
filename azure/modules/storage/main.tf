terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = var.shared_access_key_enabled

  blob_properties {
    versioning_enabled = var.enable_versioning

    dynamic "delete_retention_policy" {
      for_each = var.delete_retention_days > 0 ? [1] : []
      content {
        days = var.delete_retention_days
      }
    }

    dynamic "container_delete_retention_policy" {
      for_each = var.container_delete_retention_days > 0 ? [1] : []
      content {
        days = var.container_delete_retention_days
      }
    }

    dynamic "cors_rule" {
      for_each = var.cors_rules
      content {
        allowed_origins    = cors_rule.value.allowed_origins
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_headers    = cors_rule.value.allowed_headers
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules_enabled ? [1] : []
    content {
      default_action             = var.default_action
      bypass                     = var.bypass
      ip_rules                   = var.ip_rules
      virtual_network_subnet_ids = var.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "static_website" {
  count              = var.enable_static_website ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = var.index_document
  error_404_document = var.error_404_document
}

resource "azurerm_storage_container" "container" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_private_endpoint" "storage_pe" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_storage_account_customer_managed_key" "storage_cmk" {
  count              = var.customer_managed_key_id != null ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = var.key_vault_id
  key_name           = var.customer_managed_key_name
}

resource "azurerm_storage_management_policy" "storage_policy" {
  count              = var.enable_lifecycle_policy ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled

      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = rule.value.blob_types
      }

      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
      }
    }
  }
}
