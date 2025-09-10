# Terraform state storage account (COMMENTED OUT - Already exists manually)
# resource "azurerm_storage_account" "terraform_state" {
#   name                = local.terraform_storage_name
#   resource_group_name = azurerm_resource_group.terraform.name
#   location            = azurerm_resource_group.terraform.location

#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"

#   # Security settings
#   https_traffic_only_enabled      = true
#   min_tls_version                 = "TLS1_2"
#   allow_nested_items_to_be_public = false

#   # Access tier
#   access_tier = "Hot"

#   # Blob properties
#   blob_properties {
#     versioning_enabled = true
#     delete_retention_policy {
#       days = 30
#     }
#     container_delete_retention_policy {
#       days = 30
#     }
#   }

#   tags = local.common_tags

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# Terraform state container (COMMENTED OUT - Already exists manually)
# resource "azurerm_storage_container" "terraform_state" {
#   name                  = "tfstate"
#   storage_account_name  = azurerm_storage_account.terraform_state.name
#   container_access_type = "private"
# }

# Shared storage account for artifacts and deployment packages
resource "azurerm_storage_account" "shared" {
  name                = local.shared_storage_name
  resource_group_name = azurerm_resource_group.global.name
  location            = azurerm_resource_group.global.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Security settings
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  # Access tier
  access_tier = "Hot"

  # Blob properties
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = local.common_tags
}

# Containers for shared storage
resource "azurerm_storage_container" "deployment_packages" {
  name                  = "deployment-packages"
  storage_account_id    = azurerm_storage_account.shared.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "shared_artifacts" {
  name                  = "shared-artifacts"
  storage_account_id    = azurerm_storage_account.shared.id
  container_access_type = "private"
}
