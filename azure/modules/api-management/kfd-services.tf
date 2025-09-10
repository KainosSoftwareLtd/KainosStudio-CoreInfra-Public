resource "azurerm_api_management_api" "kfd_services" {
  name                  = "kfd-services-api"
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  revision              = "1"
  display_name          = "KFD Services API"
  path                  = ""
  protocols             = ["https"]
  subscription_required = false

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.0"
      info = {
        title       = "KFD Services API"
        version     = "1.0.0"
        description = "API for KFD file operations, matching AWS API Gateway structure exactly"
      }
      paths = {
        "/" = {
          put = {
            operationId = "upload-kfd-file"
            summary     = "Upload KFD file"
            description = "Upload a file via KFD service (matches AWS PUT /)"
            responses = {
              "200" = {
                description = "File uploaded successfully"
              }
              "400" = {
                description = "Bad request"
              }
              "500" = {
                description = "Internal server error"
              }
            }
          }
        }
        "/services/{id}" = {
          delete = {
            operationId = "delete-kfd-file"
            summary     = "Delete KFD file"
            description = "Delete a file by ID via KFD service (matches AWS DELETE /services/{id})"
            parameters = [
              {
                name     = "id"
                in       = "path"
                required = true
                schema = {
                  type = "string"
                }
                description = "File ID to delete"
              }
            ]
            responses = {
              "200" = {
                description = "File deleted successfully"
              }
              "404" = {
                description = "File not found"
              }
              "500" = {
                description = "Internal server error"
              }
            }
          }
        }
      }
    })
  }
}

resource "azurerm_api_management_api_operation" "kfd_upload" {
  operation_id        = "upload-kfd-file"
  api_name            = azurerm_api_management_api.kfd_services.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  display_name        = "Upload KFD File"
  method              = "PUT"
  url_template        = "/"
  description         = "Upload a file to KFD services (matches AWS PUT /)"

  response {
    status_code = 200
    description = "File uploaded successfully"
    representation {
      content_type = "application/json"
      example {
        name = "success"
        value = jsonencode({
          message = "File uploaded successfully"
          fileId  = "example-file-id"
        })
      }
    }
  }

  response {
    status_code = 400
    description = "Bad request"
    representation {
      content_type = "application/json"
      example {
        name = "error"
        value = jsonencode({
          error   = "Bad request"
          message = "Invalid file format or missing parameters"
        })
      }
    }
  }
}

resource "azurerm_api_management_api_operation" "kfd_delete" {
  operation_id        = "delete-kfd-file"
  api_name            = azurerm_api_management_api.kfd_services.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  display_name        = "Delete KFD File"
  method              = "DELETE"
  url_template        = "/services/{id}"
  description         = "Delete a file from KFD services (matches AWS DELETE /services/{id})"

  template_parameter {
    name        = "id"
    type        = "string"
    required    = true
    description = "The ID of the file to delete"
  }

  response {
    status_code = 200
    description = "File deleted successfully"
    representation {
      content_type = "application/json"
      example {
        name = "success"
        value = jsonencode({
          message = "File deleted successfully"
          fileId  = "example-file-id"
        })
      }
    }
  }

  response {
    status_code = 404
    description = "File not found"
    representation {
      content_type = "application/json"
      example {
        name = "error"
        value = jsonencode({
          error   = "File not found"
          message = "The specified file does not exist"
        })
      }
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "kfd_upload_policy" {
  api_name            = azurerm_api_management_api.kfd_services.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  operation_id        = azurerm_api_management_api_operation.kfd_upload.operation_id

  xml_content = templatefile("${path.module}/policies/kfd-upload-policy.xml", {
    kfd_upload_function_url = var.kfd_upload_function_url
    kfd_upload_function_key = var.kfd_upload_function_key != null ? var.kfd_upload_function_key : ""
  })
}

resource "azurerm_api_management_api_operation_policy" "kfd_delete_policy" {
  api_name            = azurerm_api_management_api.kfd_services.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  operation_id        = azurerm_api_management_api_operation.kfd_delete.operation_id

  xml_content = templatefile("${path.module}/policies/kfd-delete-policy.xml", {
    kfd_delete_function_url = var.kfd_delete_function_url
    kfd_delete_function_key = var.kfd_delete_function_key != null ? var.kfd_delete_function_key : ""
  })
}
