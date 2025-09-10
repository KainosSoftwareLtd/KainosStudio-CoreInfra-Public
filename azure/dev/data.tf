
data "terraform_remote_state" "global" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "kainoscorestate2025"
    container_name       = "tfstate"
    key                  = "global.terraform.tfstate"
  }
}

data "azurerm_resource_group" "main" {
  name = data.terraform_remote_state.global.outputs.resource_group_names["dev"]
}

data "azurerm_key_vault" "global" {
  name                = data.terraform_remote_state.global.outputs.key_vault_name
  resource_group_name = data.terraform_remote_state.global.outputs.global_resource_group_name
}

data "azurerm_log_analytics_workspace" "global" {
  name                = data.terraform_remote_state.global.outputs.log_analytics_workspace_name
  resource_group_name = data.terraform_remote_state.global.outputs.global_resource_group_name
}

data "azurerm_application_insights" "global" {
  name                = data.terraform_remote_state.global.outputs.application_insights_name
  resource_group_name = data.terraform_remote_state.global.outputs.global_resource_group_name
}

data "azurerm_key_vault_secret" "session_secret" {
  name         = "dev-session-secret"
  key_vault_id = data.azurerm_key_vault.global.id
}

