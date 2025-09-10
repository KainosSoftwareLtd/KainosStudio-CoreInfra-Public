output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "app_gateway_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.application_gateway.id
}

output "app_gateway_subnet_name" {
  description = "Name of the Application Gateway subnet"
  value       = azurerm_subnet.application_gateway.name
}
