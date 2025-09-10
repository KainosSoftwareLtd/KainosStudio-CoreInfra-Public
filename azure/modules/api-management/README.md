# API Management Module

This module provisions Azure API Management with support for KFD (Kainos File Distribution) services and core APIs.

## Features

- **Azure API Management Service**: Fully configured APIM instance with monitoring and logging
- **Multiple API Endpoints**: Supports core API, upload/delete functions, and AWS-compatible KFD services
- **Advanced Policies**: CORS, authentication, routing, and error handling
- **Monitoring**: Application Insights integration with detailed logging
- **Security**: Function key authentication and managed identity support

## APIs Provided

### 1. Core API (`/api/*`)
- General purpose API for core application functionality
- Catch-all operations for flexibility

### 2. KFD Upload API (`/kfd-upload/upload`)
- Traditional upload endpoint
- POST operations for file uploads

### 3. KFD Delete API (`/kfd-delete/delete/*`)
- Traditional delete endpoint
- DELETE operations for file removal

### 4. **KFD Services API (`/`) - AWS Compatible** ⭐
- **NEW**: AWS API Gateway compatible endpoints
- `PUT /` - Upload files (matches AWS structure exactly)
- `DELETE /services/{id}` - Delete files by ID (matches AWS structure exactly)
- Designed to provide full endpoint parity with AWS API Gateway KFD services

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Apps   │    │  Azure CDN      │    │   API Gateway   │
│                 │───▶│  (Optional)     │───▶│   (API Mgmt)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Function Apps   │    │   Policies      │    │   Backends      │
│ • Core          │◀───│ • CORS          │◀───│ • Routing       │
│ • KFD Upload    │    │ • Auth          │    │ • Load Balance  │
│ • KFD Delete    │    │ • Transform     │    │ • Health Check  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Usage

```hcl
module "api_management" {
  source = "./modules/api-management"

  # Required variables
  api_management_name      = "kainos-apim-${var.environment}"
  resource_group_name     = azurerm_resource_group.main.name
  location               = var.location

  # Function App URLs and Keys
  core_function_url        = module.core_function.function_app_url
  kfd_upload_function_url  = module.kfd_upload_function.function_app_url
  kfd_delete_function_url  = module.kfd_delete_function.function_app_url

  core_function_key        = module.core_function.function_key
  kfd_upload_function_key  = module.kfd_upload_function.function_key
  kfd_delete_function_key  = module.kfd_delete_function.function_key

  # Optional configurations
  sku_name                = "Developer_1"  # Use "Premium" for production
  allowed_origins         = ["https://myapp.com", "https://admin.myapp.com"]
  custom_domain          = "api.mycompany.com"

  tags = local.common_tags
}
```

## Key Outputs

- `api_management_gateway_url`: Primary gateway URL for all APIs
- `api_management_gateway_host`: Host for CDN origin configuration
- `kfd_services_api_name`: Name of the AWS-compatible KFD services API

## AWS Compatibility

The new **KFD Services API** provides full endpoint compatibility with AWS API Gateway KFD services:

| AWS Endpoint | Azure Endpoint | Method | Purpose |
|--------------|----------------|--------|---------|
| `PUT /` | `PUT /` | PUT | Upload files |
| `DELETE /services/{id}` | `DELETE /services/{id}` | DELETE | Delete files by ID |

This ensures seamless migration and dual-cloud operation capabilities.

## Policies and Security

- **CORS**: Configurable allowed origins
- **Authentication**: Function key-based auth with Azure Key Vault integration
- **Rate Limiting**: Built-in API Management throttling
- **Monitoring**: Full request/response logging to Application Insights
- **Error Handling**: Standardized error responses across all APIs

## Environment-Specific Configuration

Different configurations are recommended per environment:

| Environment | SKU | Features |
|-------------|-----|----------|
| Development | Developer_1 | Basic features, no SLA |
| Staging | Standard_1 | Production features, basic SLA |
| Production | Premium_1 | Full features, 99.95% SLA, multi-region |

## Monitoring and Logging

- **Application Insights**: Automatic telemetry collection
- **API Analytics**: Request/response metrics and performance data
- **Custom Logging**: Detailed operation logging with correlation IDs
- **Health Checks**: Built-in endpoint monitoring

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api_management_name | Name of the API Management service | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region location | `string` | n/a | yes |
| core_function_url | Core Function App URL | `string` | n/a | yes |
| kfd_upload_function_url | KFD Upload Function App URL | `string` | n/a | yes |
| kfd_delete_function_url | KFD Delete Function App URL | `string` | n/a | yes |
| sku_name | SKU name for API Management | `string` | `"Developer_1"` | no |
| allowed_origins | CORS allowed origins | `list(string)` | `["*"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| api_management_id | ID of the API Management service |
| api_management_gateway_url | Gateway URL of the API Management service |
| kfd_services_api_name | Name of the KFD Services API (AWS-compatible) |

## Notes

- The KFD Services API uses PUT for uploads to maintain AWS compatibility
- DELETE operations require the file ID in the URL path
- All policies support both traditional and AWS-compatible endpoints
- Function keys are securely managed through Azure Key Vault integration
