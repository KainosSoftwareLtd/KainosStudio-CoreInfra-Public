resource "azuread_application" "github_actions" {
  display_name = "kainoscore-github-actions-v2"
  description  = "Service principal for GitHub Actions CI/CD pipeline"
  owners       = [data.azurerm_client_config.current.object_id]
  tags         = ["terraform", "github-actions", "cicd", "v2"]
}

resource "azuread_service_principal" "github_actions" {
  client_id                    = azuread_application.github_actions.client_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
  tags                         = ["terraform", "github-actions", "cicd", "v2"]
}

