resource "azurerm_api_management" "apim" {
  name                 = var.api_management_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.sku_name
  virtual_network_type = var.virtual_network_type

  dynamic "virtual_network_configuration" {
    for_each = var.subnet_id != null ? [1] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "certificate" {
    for_each = var.certificates
    content {
      encoded_certificate  = certificate.value.encoded_certificate
      certificate_password = certificate.value.certificate_password
      store_name           = certificate.value.store_name
    }
  }

  tags = var.tags
}



resource "azurerm_api_management_custom_domain" "apim_domain" {
  count             = var.custom_domain != null ? 1 : 0
  api_management_id = azurerm_api_management.apim.id

  gateway {
    host_name                    = var.custom_domain
    negotiate_client_certificate = false
    certificate                  = var.ssl_certificate_key_vault_secret_id != null ? var.ssl_certificate_key_vault_secret_id : null
  }
}
