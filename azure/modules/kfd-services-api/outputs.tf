output "kfd_services_api_name" {
  description = "Name of the KFD Services API (AWS-compatible endpoints)"
  value       = azurerm_api_management_api.kfd_services.name
}

output "kfd_services_api_id" {
  description = "ID of the KFD Services API"
  value       = azurerm_api_management_api.kfd_services.id
}

output "kfd_upload_backend_name" {
  description = "Name of the KFD Upload backend"
  value       = azurerm_api_management_backend.kfd_upload_backend.name
}

output "kfd_delete_backend_name" {
  description = "Name of the KFD Delete backend"
  value       = azurerm_api_management_backend.kfd_delete_backend.name
}
