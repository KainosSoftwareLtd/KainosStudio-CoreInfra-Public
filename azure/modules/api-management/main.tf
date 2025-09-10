terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

resource "azurerm_api_management" "apim" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name

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

  additional_location {
    location = var.location
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

resource "azurerm_application_insights" "apim_insights" {
  name                = "${var.api_management_name}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = var.tags
}

resource "azurerm_api_management_logger" "apim_logger" {
  name                = "${var.api_management_name}-logger"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = azurerm_application_insights.apim_insights.instrumentation_key
  }
}

resource "azurerm_api_management_api" "core_api" {
  name                  = "core-api"
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "Kainos Core API"
  path                  = "api"
  protocols             = ["https"]
  service_url           = var.core_function_url
  subscription_required = false

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.0"
      info = {
        title   = "Kainos Core API"
        version = "1.0.0"
      }
      paths = {
        "/*" = {
          get = {
            operationId = "get-core"
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
          post = {
            operationId = "post-core"
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
        }
      }
    })
  }
}

resource "azurerm_api_management_api" "kfd_upload_api" {
  name                  = "kfd-upload-api"
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "KFD Upload API"
  path                  = "kfd-upload"
  protocols             = ["https"]
  service_url           = var.kfd_upload_function_url
  subscription_required = false

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.0"
      info = {
        title   = "KFD Upload API"
        version = "1.0.0"
      }
      paths = {
        "/upload" = {
          post = {
            operationId = "upload-kfd"
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
        }
      }
    })
  }
}

resource "azurerm_api_management_api" "kfd_delete_api" {
  name                  = "kfd-delete-api"
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "KFD Delete API"
  path                  = "kfd-delete"
  protocols             = ["https"]
  service_url           = var.kfd_delete_function_url
  subscription_required = false

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.0"
      info = {
        title   = "KFD Delete API"
        version = "1.0.0"
      }
      paths = {
        "/delete/*" = {
          delete = {
            operationId = "delete-kfd"
            responses = {
              "200" = {
                description = "Success"
              }
            }
          }
        }
      }
    })
  }
}

resource "azurerm_api_management_api_operation" "core_catchall" {
  operation_id        = "core-catchall"
  api_name            = azurerm_api_management_api.core_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Core Catch All"
  method              = "*"
  url_template        = "/*"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_backend" "core_backend" {
  name                = "core-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                 = var.core_function_url

  credentials {
    header = {
      "x-functions-key" = var.core_function_key != null ? var.core_function_key : ""
    }
  }
}

resource "azurerm_api_management_backend" "kfd_upload_backend" {
  name                = "kfd-upload-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                 = var.kfd_upload_function_url

  credentials {
    header = {
      "x-functions-key" = var.kfd_upload_function_key != null ? var.kfd_upload_function_key : ""
    }
  }
}

resource "azurerm_api_management_backend" "kfd_delete_backend" {
  name                = "kfd-delete-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                 = var.kfd_delete_function_url

  credentials {
    header = {
      "x-functions-key" = var.kfd_delete_function_key != null ? var.kfd_delete_function_key : ""
    }
  }
}

resource "azurerm_api_management_api_policy" "core_api_policy" {
  api_name            = azurerm_api_management_api.core_api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  xml_content = templatefile("${path.module}/policies/api-policy.xml", {
    backend_id      = azurerm_api_management_backend.core_backend.name
    allowed_origins = jsonencode(var.allowed_origins)
  })
}

resource "azurerm_api_management_policy" "global_policy" {
  api_management_id = azurerm_api_management.apim.id

  xml_content = templatefile("${path.module}/policies/global-policies.xml", {
    allowed_origins = jsonencode(var.allowed_origins)
  })
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
