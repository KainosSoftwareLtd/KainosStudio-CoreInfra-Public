# KFD Services API Module

This module creates AWS-compatible KFD Services API for an existing API Management service. It provides exact endpoint compatibility with AWS API Gateway KFD services.

## Features

- **AWS-Compatible Endpoints**: Exact match with AWS API Gateway structure
- **Upload Operation**: `PUT /` - Upload files (matches AWS)
- **Delete Operation**: `DELETE /services/{id}` - Delete files (matches AWS)
- **Advanced Policies**: Request transformation, CORS, authentication
- **Backend Configuration**: Routes to KFD Upload and Delete Function Apps
- **OpenAPI Specification**: Complete API documentation

## Usage

```hcl
module "kfd_services_api" {
  source = "../modules/kfd-services-api"

  # API Management reference
  api_management_name = module.api_management_service.api_management_name
  resource_group_name = var.resource_group_name

  # Function App configuration
  kfd_upload_function_url = module.kfd_upload_function_app.function_app_url
  kfd_delete_function_url = module.kfd_delete_function_app.function_app_url

  kfd_upload_function_key = module.kfd_upload_function_app.function_key
  kfd_delete_function_key = module.kfd_delete_function_app.function_key
}
```

## API Endpoints (AWS Compatible)

| Endpoint | Method | Purpose | AWS Equivalent |
|----------|--------|---------|----------------|
| `PUT /` | PUT | Upload files | `PUT /` |
| `DELETE /services/{id}` | DELETE | Delete files | `DELETE /services/{id}` |

## Policy Features

- **Upload Policy**: Transforms PUT to POST, routes to upload function
- **Delete Policy**: Extracts file ID, routes to delete function
- **CORS Support**: Cross-origin resource sharing
- **Authentication**: Function key-based authentication
- **Error Handling**: Standardized error responses

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api_management_name | Name of the API Management service | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| kfd_upload_function_url | KFD Upload Function App URL | `string` | n/a | yes |
| kfd_delete_function_url | KFD Delete Function App URL | `string` | n/a | yes |
| kfd_upload_function_key | KFD Upload Function App key | `string` | `null` | no |
| kfd_delete_function_key | KFD Delete Function App key | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| kfd_services_api_name | Name of the KFD Services API |
| kfd_services_api_id | ID of the KFD Services API |
| kfd_upload_backend_name | Name of the KFD Upload backend |
| kfd_delete_backend_name | Name of the KFD Delete backend |

## Dependencies

- Requires an existing API Management service
- Requires deployed KFD Upload and Delete Function Apps

## AWS Compatibility

This module provides **100% endpoint compatibility** with AWS API Gateway KFD services, enabling:
- Seamless cross-cloud operation
- Zero application code changes
- Identical API contracts
