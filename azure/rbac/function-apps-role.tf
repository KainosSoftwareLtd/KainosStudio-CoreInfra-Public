resource "azurerm_role_definition" "kainoscore_function_app" {
  name        = "KainosCore Function App Role"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "Custom role for KainosCore Function Apps with specific permissions"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/listKeys/action",
      "Microsoft.Storage/storageAccounts/blobServices/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
      "Microsoft.DocumentDB/databaseAccounts/read",
      "Microsoft.DocumentDB/databaseAccounts/readonlykeys/action",
      "Microsoft.DocumentDB/databaseAccounts/listKeys/action",
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Insights/components/read",
      "Microsoft.Insights/components/api/read",
      "Microsoft.Insights/webtests/read"
    ]

    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
      "Microsoft.KeyVault/vaults/secrets/getSecret/action"
    ]
  }

  assignable_scopes = [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  ]
}

# Custom role for GitHub Actions CI/CD
resource "azurerm_role_definition" "github_actions_cicd" {
  name        = "KainosCore GitHub Actions CI/CD"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "Custom role for GitHub Actions with deployment permissions"

  permissions {
    actions = [
      # Resource Group permissions
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",

      # Function App permissions
      "Microsoft.Web/sites/*",
      "Microsoft.Web/serverfarms/*",
      "Microsoft.Web/connections/*",

      # Storage permissions
      "Microsoft.Storage/storageAccounts/*",

      # Cosmos DB permissions
      "Microsoft.DocumentDB/databaseAccounts/*",

      # Key Vault permissions
      "Microsoft.KeyVault/vaults/*",

      # API Management permissions
      "Microsoft.ApiManagement/*",

      # Monitor permissions
      "Microsoft.Insights/*",
      "Microsoft.OperationalInsights/*",

      # Network permissions
      "Microsoft.Network/virtualNetworks/*",
      "Microsoft.Network/networkSecurityGroups/*",
      "Microsoft.Network/applicationGateways/*",

      # CDN permissions
      "Microsoft.Cdn/*",

      # Role assignment permissions (limited)
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",

      # Deployment permissions
      "Microsoft.Resources/deployments/*",
      "Microsoft.Resources/templateSpecs/*",

      # Tag permissions
      "Microsoft.Resources/tags/*"
    ]

    not_actions = [
      # Restrict some dangerous actions
      "Microsoft.Authorization/*/Delete",
      "Microsoft.Authorization/elevateAccess/Action",
      "Microsoft.Authorization/classicAdministrators/*"
    ]
  }

  assignable_scopes = [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  ]
}
