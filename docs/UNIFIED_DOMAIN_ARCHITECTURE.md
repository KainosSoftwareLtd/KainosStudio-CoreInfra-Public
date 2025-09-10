# Unified Domain Architecture Implementation Guide

## Overview

This document explains how to implement a unified domain architecture in Azure that replicates your AWS CloudFront setup, where a single domain serves both static assets and dynamic content through intelligent routing.

## Architecture Comparison

### AWS CloudFront (Current)
```
https://dev.kainoscore.com/
├── /assets/* → S3 Static Website
├── /public/* → S3 Static Website
└── /* (default) → API Gateway → Lambda Functions (KFD forms)
```

### Azure Application Gateway (Recommended)
```
https://dev.kainoscore.com/
├── /assets/* → Static Website (kainoscorestaticdev.z33.web.core.windows.net)
├── /public/* → Static Website (kainoscorestaticdev.z33.web.core.windows.net)
└── /* (default) → API Management → Azure Functions (KFD forms)
```

## Implementation Options

### Option 1: Application Gateway (Recommended)
**Pros:**
- Exact CloudFront equivalent
- Layer 7 load balancing with path-based routing
- SSL termination
- WAF capabilities
- Single public IP and domain

**Cons:**
- More complex setup
- Higher cost
- Requires subnet for deployment

### Option 2: API Management with Multiple Backends
**Pros:**
- Leverages existing API Management
- Simpler configuration
- Built-in developer portal

**Cons:**
- API Management focused, not optimized for static content
- More expensive for high traffic static content

### Option 3: CDN with Multiple Endpoints + DNS routing
**Pros:**
- Uses Azure CDN (similar to CloudFront)
- Good caching performance
- Lower cost for static content

**Cons:**
- Requires client-side routing or complex DNS setup
- Multiple endpoints to manage

## Recommended Implementation: Option 1 (Application Gateway)

### Step 1: Deploy Application Gateway
```bash
# Add to your terraform.tfvars
application_gateway_subnet_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
enable_application_gateway_ssl = false  # Start with HTTP for testing
enable_application_gateway_waf = false  # Enable later for security
```

### Step 2: Deploy the infrastructure
```bash
cd azure/dev
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Step 3: Test the routing
After deployment, you'll get an Application Gateway public IP. Test:

```bash
# Test static assets (should route to storage account)
curl http://APPLICATION_GATEWAY_IP/assets/images/govuk-icon-180.png

# Test API calls (should route to API Management)
curl http://APPLICATION_GATEWAY_IP/api/health

# Test KFD forms (should route to API Management → Functions)
curl http://APPLICATION_GATEWAY_IP/forms/render
```

### Step 4: Configure DNS
Point your domain (dev.kainoscore.com) to the Application Gateway public IP:

```
dev.kainoscore.com → A record → APPLICATION_GATEWAY_IP
```

### Step 5: Enable SSL (Production)
1. Obtain SSL certificate for dev.kainoscore.com
2. Convert to base64 and update terraform.tfvars:
```hcl
enable_application_gateway_ssl = true
ssl_certificate_data = "base64_encoded_certificate_data"
ssl_certificate_password = "certificate_password"
application_gateway_custom_domain = "dev.kainoscore.com"
```

## How Path-Based Routing Works

The Application Gateway configuration includes:

```hcl
# Static assets route to storage account
path_rule {
  name                       = "assets-rule"
  paths                      = ["/assets/*"]
  backend_address_pool_name  = "static-content-pool"    # → storage account
  backend_http_settings_name = "static-content-http-settings"
}

path_rule {
  name                       = "public-rule"
  paths                      = ["/public/*"]
  backend_address_pool_name  = "static-content-pool"    # → storage account
  backend_http_settings_name = "static-content-http-settings"
}

# Default: everything else goes to API Management
default_backend_address_pool_name  = "api-management-pool"     # → API Management
default_backend_http_settings_name = "api-management-http-settings"
```

## Backend Configuration

### Static Content Backend
- **Target**: `kainoscorestaticdev.z33.web.core.windows.net`
- **Protocol**: HTTPS
- **Health Probe**: `GET /` (404 is acceptable)

### API Management Backend
- **Target**: `kainoscore-api-dev.azure-api.net` (your API Management gateway)
- **Protocol**: HTTPS
- **Health Probe**: `GET /status-0123456789abcdef`

## Testing Your Implementation

### 1. Static Assets Test
```bash
# Direct storage access (should work)
curl https://kainoscorestaticdev.z33.web.core.windows.net/assets/images/govuk-icon-180.png

# Through Application Gateway (should work)
curl http://APPLICATION_GATEWAY_IP/assets/images/govuk-icon-180.png
```

### 2. API Management Test
```bash
# Direct API Management access (should work)
curl https://kainoscore-api-dev.azure-api.net/api/health

# Through Application Gateway (should work)
curl http://APPLICATION_GATEWAY_IP/api/health
```

### 3. KFD Forms Test
```bash
# Test form rendering through Application Gateway
curl http://APPLICATION_GATEWAY_IP/forms/render

# This should:
# 1. Route to API Management
# 2. Execute Azure Function
# 3. Return dynamically rendered form content
```

## Migration from Current Setup

### Phase 1: Deploy Application Gateway (Testing)
- Deploy with HTTP only
- Test all routing paths
- Verify static assets and API calls work

### Phase 2: DNS Switch (Staging)
- Update DNS to point to Application Gateway
- Monitor traffic and performance
- Fix any routing issues

### Phase 3: SSL Enable (Production)
- Add SSL certificate
- Enable HTTPS redirect
- Update all internal links

### Phase 4: Optimization
- Enable WAF for security
- Tune backend settings
- Configure monitoring and alerts

## Troubleshooting

### Static Assets Return 404
- Verify storage account static website hosting is enabled
- Check that files exist in `$web` container
- Verify Application Gateway backend pool configuration

### API Calls Fail
- Check API Management gateway URL
- Verify API Management health probe
- Check CORS configuration

### Form Rendering Issues
- Verify Azure Functions are running
- Check Function App logs
- Test API Management → Functions connection directly

## Cost Considerations

### Application Gateway
- **Standard_v2**: ~$0.36/hour + $0.008/capacity unit
- **WAF_v2**: ~$0.443/hour + $0.008/capacity unit

### Comparison
- Similar to AWS CloudFront + ALB pricing
- Higher than CDN-only but provides more features
- Cost effective for mixed static/dynamic content

## Security Features

- **WAF**: Protection against common web attacks
- **SSL Termination**: Centralized certificate management
- **DDoS Protection**: Basic protection included
- **Backend Authentication**: Secure communication to backends

## Next Steps

1. **Create Application Gateway subnet** (if not exists)
2. **Deploy Application Gateway module**
3. **Test routing functionality**
4. **Configure DNS and SSL**
5. **Enable WAF and monitoring**

This architecture gives you the exact same functionality as your AWS CloudFront setup while leveraging Azure's native services.
