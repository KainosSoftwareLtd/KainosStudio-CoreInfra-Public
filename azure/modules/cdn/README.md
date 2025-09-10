# Azure CDN Module

This module creates an Azure CDN profile with endpoints for API and static content distribution.

## Features

- Azure CDN Profile with configurable SKU
- API endpoint with caching rules and CORS support
- Optional static content endpoint for web assets
- Custom domain support with managed SSL certificates
- Performance optimization settings
- Security features (HTTPS enforcement, cache headers)

## Usage

```terraform
module "cdn" {
  source = "../modules/cdn"

  # CDN Profile Configuration
  cdn_profile_name    = "myapp-cdn-dev"
  resource_group_name = "myapp-dev-rg"
  location            = "UK South"
  cdn_sku             = "Standard_Microsoft"

  # API CDN Endpoint
  api_endpoint_name = "myapp-api-dev"
  api_origin_host   = "myapp-api.azure-api.net"

  # CORS Configuration
  allowed_origins = ["https://myapp.com"]

  # Static Content CDN Endpoint (optional)
  enable_static_endpoint = true
  static_endpoint_name   = "myapp-static-dev"
  static_origin_host     = "mystorageaccount.z33.web.core.windows.net"

  # CDN Configuration
  optimization_type    = "GeneralWebDelivery"
  allow_http          = false
  querystring_caching = "IgnoreQueryString"

  tags = {
    Environment = "dev"
    Project     = "MyApp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cdn_profile_name | Name of the Azure CDN profile | `string` | n/a | yes |
| location | Azure region where the CDN profile will be created | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| cdn_sku | SKU for the CDN profile | `string` | `"Standard_Microsoft"` | no |
| api_endpoint_name | Name of the API CDN endpoint | `string` | n/a | yes |
| api_origin_host | Origin host for the API endpoint | `string` | n/a | yes |
| api_origin_path | Origin path for the API endpoint | `string` | `""` | no |
| allowed_origins | List of allowed origins for CORS | `list(string)` | `["*"]` | no |
| enable_static_endpoint | Whether to create a static content endpoint | `bool` | `false` | no |
| static_endpoint_name | Name of the static content CDN endpoint | `string` | `""` | no |
| static_origin_host | Origin host for static content | `string` | `""` | no |
| optimization_type | Optimization type for the CDN endpoint | `string` | `"GeneralWebDelivery"` | no |
| allow_http | Whether to allow HTTP traffic | `bool` | `false` | no |
| querystring_caching | Query string caching behavior | `string` | `"IgnoreQueryString"` | no |
| custom_domain_name | Custom domain name for the CDN endpoint | `string` | `null` | no |
| enable_custom_domain | Enable custom domain configuration (requires certificate) | `bool` | `false` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Deployment Strategy

This module supports a two-phase deployment approach:

### Phase 1: Testing with Azure CDN Domain
```terraform
module "cdn" {
  source = "../modules/cdn"

  # Basic configuration
  cdn_profile_name = "myapp-cdn-dev"
  api_endpoint_name = "myapp-api-dev"
  api_origin_host = "myapp-api.azure-api.net"

  # Use default Azure CDN domain for testing
  enable_custom_domain = false
  custom_domain_name = null

  # ... other configuration
}
```

This creates a CDN that uses the Azure-provided domain (e.g., `myapp-api-dev.azureedge.net`) which you can use to test CDN functionality without needing certificates.

### Phase 2: Production with Custom Domain
```terraform
module "cdn" {
  source = "../modules/cdn"

  # Same basic configuration
  cdn_profile_name = "myapp-cdn-dev"
  api_endpoint_name = "myapp-api-dev"
  api_origin_host = "myapp-api.azure-api.net"

  # Enable custom domain with certificate
  enable_custom_domain = true
  custom_domain_name = "api.myapp.com"

  # ... other configuration
}
```

This enables the custom domain with automatic SSL certificate management.

## Outputs

| Name | Description |
|------|-------------|
| cdn_profile_id | ID of the CDN profile |
| cdn_profile_name | Name of the CDN profile |
| api_endpoint_id | ID of the API CDN endpoint |
| api_endpoint_fqdn | FQDN of the API CDN endpoint |
| api_endpoint_url | URL of the API CDN endpoint |
| static_endpoint_id | ID of the static content CDN endpoint |
| static_endpoint_fqdn | FQDN of the static content CDN endpoint |
| static_endpoint_url | URL of the static content CDN endpoint |
| custom_domain_fqdn | FQDN of the custom domain (if configured) |

## Cache Rules

### API Endpoint
- **API responses** (`/api/*`): 1 day cache duration
- **CORS headers**: Automatic addition for OPTIONS requests
- **Cache-Control**: Public caching with max-age

### Static Content Endpoint (if enabled)
- **Static assets** (js, css, images, fonts): 1 year cache duration with immutable flag
- **HTML files**: 1 day cache duration
- **Query strings**: Ignored for caching

## Security Features

- **HTTPS Enforcement**: HTTP traffic redirected to HTTPS
- **Custom Domain SSL**: Automatic SSL certificate management
- **CORS Support**: Configurable allowed origins
- **Cache Headers**: Proper cache control headers added

## Performance Optimization

- **General Web Delivery**: Optimized for typical web content
- **Gzip/Brotli**: Compression enabled for supported content
- **Global Edge Locations**: Content served from nearest Azure edge location

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.10.0 |
| azurerm | ~> 3.116.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.116.0 |

## Resources

- azurerm_cdn_profile
- azurerm_cdn_endpoint (API)
- azurerm_cdn_endpoint (Static, optional)
- azurerm_cdn_endpoint_custom_domain (optional)

## Example: Complete Setup

```terraform
# API Management
module "api_management" {
  source = "../modules/api-management"
  # ... configuration
}

# Storage Account
module "storage" {
  source = "../modules/storage"
  # ... configuration
}

# CDN with both API and static endpoints
module "cdn" {
  source = "../modules/cdn"

  cdn_profile_name    = "myapp-cdn-dev"
  resource_group_name = "myapp-dev-rg"
  location            = "UK South"

  # API endpoint using API Management as origin
  api_endpoint_name = "myapp-api-dev"
  api_origin_host   = module.api_management.api_management_gateway_host

  # Static endpoint using Storage Account as origin
  enable_static_endpoint = true
  static_endpoint_name   = "myapp-static-dev"
  static_origin_host     = module.storage.storage_account_primary_web_host

  # Custom domain (optional - for production)
  custom_domain_name = "api.myapp.com"
  enable_custom_domain = true  # Set to false for testing with Azure CDN domain

  depends_on = [
    module.api_management,
    module.storage
  ]
}
```
