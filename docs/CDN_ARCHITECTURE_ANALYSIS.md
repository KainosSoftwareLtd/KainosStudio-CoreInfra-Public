# Azure CDN Architecture Analysis & Recommendations

## Current AWS CloudFront Setup Analysis

Your AWS setup uses CloudFront with intelligent routing:

### Origins:
1. **API Gateway Origin (Default)**: `${api-id}.execute-api.${region}.amazonaws.com`
   - Handles all dynamic content, form rendering, API calls
   - Default behavior for all unmatched paths
   - Caching policy optimized for API responses

2. **S3 Origin**: Static website hosting
   - Handles `/assets/*` and `/public/*` paths
   - Long-term caching for static assets
   - Origin Access Control for security

### Path-Based Routing:
- `/*` (default) → API Gateway (for KFD forms, dynamic content)
- `/assets/*` → S3 (static assets)
- `/public/*` → S3 (public static files)


## Azure CDN / Front Door Architecture Options

### Option 1: Azure Front Door/CDN with Multiple Origins (Recommended)

This mirrors your AWS setup most closely:

```
Azure Front Door/CDN Profile
├── API Origin (Primary)
│   ├── Origin: API Management
│   ├── Default behavior: All traffic except /assets/* and /public/*
│
└── Static Origin (Secondary)
   ├── Origin: Storage Account Static Website
   ├── Handles: /assets/* and /public/*
   └── Long-term caching for static content
```

**Pros:**
- Exact AWS CloudFront equivalent
- Separate caching policies per content type
- Better performance isolation
- Easier debugging and monitoring

**Cons:**
- Requires client-side routing or load balancer
- Two different endpoints to manage


### Option 2: Single Front Door/CDN Endpoint with Path-Based Routing (Alternative)

Single endpoint with path-based routing rules:

```
Azure Front Door/CDN Profile
└── Unified Endpoint
   ├── Primary Origin: API Management
   ├── Secondary Origin: Storage Account Static Website
   └── Routing Rules:
      ├── /assets/* → Static Website Origin
      ├── /public/* → Static Website Origin
      └── /* → API Management Origin (default)
```

**Pros:**
- Single endpoint URL
- Simpler client configuration
- Path-based origin routing

**Cons:**
- More complex delivery rules
- Limited origin switching capabilities in Azure CDN


## Recommended Implementation: Option 1

Based on your current AWS setup, I recommend **Option 1** with the following configuration:

### 1. Static Website Hosting vs Blob Storage

**Use Static Website Hosting** because:
- Serves `index.html` automatically for directory requests
- Better integration with CDN
- Supports custom error pages (404.html)
- Matches your S3 static website hosting setup
- The `$web` container is created automatically when enabled

### 2. API Management Integration

Your current API Management setup should handle:
- KFD form rendering (dynamic content)
- API endpoints for form submissions
- Authentication and authorization
- CORS configuration


### 3. Front Door/CDN Configuration Strategy

```hcl
# Main Front Door/CDN for API Management (Dynamic Content)
resource "azurerm_cdn_frontdoor_origin" "api_origin" {
   # Handles all dynamic content, forms, API calls
   # Origin: API Management Gateway
   # Caching: Short-term for API responses
}

# Secondary Front Door/CDN for Static Content
resource "azurerm_cdn_frontdoor_origin" "static_origin" {
   # Handles /assets/*, /public/*, static files
   # Origin: Storage Account Static Website Endpoint
   # Caching: Long-term for static assets
}
```

## Required Configuration Changes

### 1. Enable Static Website Hosting
```terraform
# In storage module
resource "azurerm_storage_account_static_website" "static" {
  storage_account_id = azurerm_storage_account.main.id
  index_document     = var.index_document
  error_404_document = var.error_404_document
}
```

### 2. Update CDN Origins
```terraform
# Static CDN should point to static website endpoint
static_origin_host = module.static_storage.storage_account_primary_web_endpoint
# NOT the blob endpoint
```

### 3. Add Path-Based Routing (Optional)
If you want a single endpoint, add delivery rules for path-based routing.

## Client-Side Integration Options

### Option A: Separate Endpoints (Recommended)
```javascript
// Frontend configuration
const config = {
  apiEndpoint: 'https://api-cdn-endpoint.azureedge.net',
  staticEndpoint: 'https://static-cdn-endpoint.azureedge.net',
  assetsPath: '/assets/',
  publicPath: '/public/'
};

// Asset URLs
const assetUrl = `${config.staticEndpoint}${config.assetsPath}image.png`;
const apiUrl = `${config.apiEndpoint}/api/forms/render`;
```


### Option B: Front Door/CDN Routing
Use Azure Front Door/CDN to route:
- `/assets/*` → Static Origin
- `/public/*` → Static Origin
- `/*` → API Origin

## Security Considerations

1. **Storage Account Access**:
   - Disable public blob access
   - Use static website hosting only
   - Enable CDN-only access if possible

2. **API Management**:
   - Configure CORS for CDN origins
   - Use managed identity for backend services
   - Enable rate limiting and throttling

3. **CDN Security**:
   - Enable HTTPS only
   - Configure custom domains with SSL
   - Set appropriate cache headers


## Migration Path from Current Setup

1. **Phase 1**: Ensure static website hosting is enabled
2. **Phase 2**: Configure Front Door/CDN origins
3. **Phase 3**: Update application to use unified endpoint
4. **Phase 4**: Test and validate functionality
5. **Phase 5**: Optimize caching policies

## Verification Steps

1. **Static Website Hosting**:
   ```bash
   az storage blob service-properties show \
     --account-name ${storage_account} \
     --query "staticWebsite"
   ```

2. **Upload Test Files**:
   ```bash
   az storage blob upload \
     --account-name ${storage_account} \
     --container-name '$web' \
     --name 'assets/test.png' \
     --file test.png
   ```

3. **Test CDN Endpoints**:
   ```bash
   curl https://static-cdn-endpoint.azureedge.net/assets/test.png
   curl https://api-cdn-endpoint.azureedge.net/api/health
   ```

## Conclusion

The recommended approach is to use **Static Website Hosting** with **separate CDN endpoints** for API and static content, mirroring your successful AWS CloudFront architecture. This provides the best performance, caching flexibility, and maintains the same logical separation you have with AWS.
