terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "key_vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # Network access - Defaults to false for security, explicit enablement required for development
  public_network_access_enabled = var.public_network_access_enabled != null ? var.public_network_access_enabled : false

  dynamic "network_acls" {
    for_each = var.network_acls_enabled ? [1] : []
    content {
      bypass                     = var.network_acls_bypass
      default_action             = var.network_acls_default_action
      ip_rules                   = var.network_acls_ip_rules
      virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

# Key Vault Access Policy for current client
resource "azurerm_key_vault_access_policy" "current_client" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Delete", "Get", "List", "Update", "Import", "Backup", "Restore", "Recover"
  ]

  secret_permissions = [
    "Set", "Get", "Delete", "List", "Backup", "Restore", "Recover"
  ]

  certificate_permissions = [
    "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers",
    "ManageContacts", "ManageIssuers", "SetIssuers", "Update", "Backup", "Restore", "Recover"
  ]
}

# Additional access policies
resource "azurerm_key_vault_access_policy" "additional_policies" {
  count        = length(var.access_policies)
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.access_policies[count.index].object_id

  key_permissions         = var.access_policies[count.index].key_permissions
  secret_permissions      = var.access_policies[count.index].secret_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
}

# Key Vault Secrets
resource "azurerm_key_vault_secret" "secrets" {
  count        = length(var.secrets)
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = var.secrets[count.index].name
  value        = var.secrets[count.index].value
  content_type = var.secrets[count.index].content_type

  tags = var.tags

  depends_on = [azurerm_key_vault_access_policy.current_client]
}

# Key Vault Keys
resource "azurerm_key_vault_key" "keys" {
  count        = length(var.keys)
  key_vault_id = azurerm_key_vault.key_vault.id
  name         = var.keys[count.index].name
  key_type     = var.keys[count.index].key_type
  key_size     = var.keys[count.index].key_size
  key_opts     = var.keys[count.index].key_opts

  tags = var.tags

  depends_on = [azurerm_key_vault_access_policy.current_client]
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault_pe" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.key_vault_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}
