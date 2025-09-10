# Custom role definition outputs
output "kainoscore_function_app_role_id" {
  description = "ID of the KainosCore Function App custom role"
  value       = azurerm_role_definition.kainoscore_function_app.role_definition_resource_id
}

output "github_actions_cicd_role_id" {
  description = "ID of the GitHub Actions CI/CD custom role"
  value       = azurerm_role_definition.github_actions_cicd.role_definition_resource_id
}

# Role assignment outputs
output "role_assignments" {
  description = "Summary of role assignments"
  value = {
    # GitHub Actions role assignments (now active)
    github_actions_subscription = azurerm_role_assignment.github_actions_subscription.id
    github_actions_key_vault    = azurerm_role_assignment.github_actions_key_vault.id
    github_actions_storage      = azurerm_role_assignment.github_actions_storage.id
    github_actions_monitoring   = azurerm_role_assignment.github_actions_monitoring.id

    # Custom CI/CD role still commented out since we didn't uncomment that one
    # github_actions_cicd         = azurerm_role_assignment.github_actions_cicd.id
  }
}
