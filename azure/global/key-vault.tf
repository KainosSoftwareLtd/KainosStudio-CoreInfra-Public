
module "key_vault" {
  source                        = "../modules/key-vault"
  key_vault_name                = local.key_vault_name
  resource_group_name           = azurerm_resource_group.global.name
  location                      = azurerm_resource_group.global.location
  sku_name                      = var.key_vault_sku
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = true
  tags                          = local.common_tags
  secrets = concat(
    [
      {
        name         = "github-actions-client-id"
        value        = azuread_application.github_actions.client_id
        content_type = "GitHub Actions Service Principal Client ID"
      },
      {
        name         = "tenant-id"
        value        = data.azurerm_client_config.current.tenant_id
        content_type = "Azure Tenant ID"
      },
      {
        name         = "subscription-id"
        value        = data.azurerm_client_config.current.subscription_id
        content_type = "Azure Subscription ID"
      }
    ],
    [
      for env in var.environments : {
        name         = "${env}-session-secret"
        value        = "kainos-studio-${env}-${random_password.session_secrets[env].result}"
        content_type = "Session Secret for ${env} environment"
      }
    ]
  )
}

resource "random_password" "session_secrets" {
  for_each = toset(var.environments)
  length   = 32
  special  = true
}

