# API Management Service Module

This module provisions the base Azure API Management service infrastructure without any APIs. It provides the foundation that other API modules can use.

## Features

- **Azure API Management Service**: Base APIM instance
- **Application Insights**: Monitoring and logging
- **Global Policies**: CORS, security headers, and request tracking
- **Managed Identity**: System-assigned identity for secure access
- **Custom Domain**: Optional custom domain configuration

## Usage

```hcl
module "api_management_service" {
  source = "../modules/api-management-service"

  # Required variables
  api_management_name = "kainos-apim-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location           = var.location

  # Optional configurations
  sku_name           = "Developer_1"  # Use "Premium" for production
  allowed_origins    = ["https://myapp.com"]

  tags = local.common_tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api_management_name | Name of the API Management service | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region location | `string` | n/a | yes |
| sku_name | SKU name for API Management | `string` | `"Developer_1"` | no |
| allowed_origins | CORS allowed origins | `list(string)` | `["*"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| api_management_id | ID of the API Management service |
| api_management_name | Name of the API Management service |
| api_management_gateway_url | Gateway URL of the API Management service |

## Notes

- This module creates only the base API Management service
- Individual APIs should be created using separate API modules
- Depends on no external APIs or function apps
