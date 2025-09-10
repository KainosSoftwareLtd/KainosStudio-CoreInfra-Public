output "function_app_id" {
  description = "ID of the Function App"
  value       = azurerm_linux_function_app.function_app.id
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_linux_function_app.function_app.name
}

output "function_app_hostname" {
  description = "Hostname of the Function App"
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_url" {
  description = "URL of the Function App"
  value       = "https://${azurerm_linux_function_app.function_app.default_hostname}"
}

output "function_app_identity" {
  description = "Managed Identity of the Function App"
  value = {
    principal_id = azurerm_linux_function_app.function_app.identity[0].principal_id
    tenant_id    = azurerm_linux_function_app.function_app.identity[0].tenant_id
  }
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = var.global_application_insights_key != null ? var.global_application_insights_key : azurerm_application_insights.function_app_insights[0].instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights connection string"
  value       = var.global_application_insights_connection_string != null ? var.global_application_insights_connection_string : azurerm_application_insights.function_app_insights[0].connection_string
  sensitive   = true
}

output "deployment_info" {
  description = "Deployment configuration information (legacy fields maintained for compatibility; code deployed via CI/CD)."
  value = {
    package_url             = null
    enable_blob_deployment  = false
    deployment_storage_name = null
    deployment_container    = null
    deployment_method       = "cicd_zip_deploy"
  }
}

output "kudu_url" {
  description = "Kudu SCM URL for deployment operations"
  value       = "https://${azurerm_linux_function_app.function_app.name}.scm.azurewebsites.net"
}

output "effective_run_from_package" {
  description = "Indicator that run-from-package is managed externally (CI/CD)."
  value       = local.function_app_effective_run_from_package
}