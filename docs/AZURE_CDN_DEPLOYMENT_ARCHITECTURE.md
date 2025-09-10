# Azure CDN Deployment Architecture

## ✅ Current Implementation Overview

The Azure infrastructure implements a **hybrid CDN routing architecture** that separates form operations from file operations for optimal performance and API management capabilities.

## 🏗️ Architecture Diagram

```
Azure Front Door CDN Endpoint
├── Static Assets Routes
│   ├── /assets/* → Storage Account Static Website
│   └── /public/* → Storage Account Static Website
│
├── File Operations Routes (Future: Separate APIM)
│   ├── /services/* → Dedicated APIM → KFD Delete Function App
│   └── /upload/* → Dedicated APIM → KFD Upload Function App
│
└── Form Operations Route (Default - Current)
    └── /* → Core Function App (Direct)
        ├── GET / → Form rendering
        ├── GET /{form_id} → Specific form display
        ├── POST / → Form submission
        └── Internal routing based on form_id logic
```

## 🎯 Key Architectural Decisions

### 1. **Hybrid Routing Strategy**
- **Form Operations**: Direct CDN → Function App routing for optimal performance
- **File Operations**: CDN → Dedicated APIM → Function Apps for API management features
- **Static Assets**: CDN → Storage Account for maximum caching efficiency

### 2. **Separate APIM for File Operations**
- **Current State**: Form operations bypass APIM for performance
- **Future State**: Dedicated APIM instance will handle file upload/delete operations
- **Rationale**: Separates concerns and provides API management features where needed

## 📊 Current vs Planned Implementation

### ✅ Currently Deployed & Working

#### CDN Origin Groups
1. **Static Content Origin Group**
   - **Purpose**: Serves static assets with aggressive caching
   - **Origin**: Storage Account Static Website (`$web` container)
   - **Health Probe**: `HEAD /`
   - **Caching**: 1 day with compression

2. **Function App Origin Group**
   - **Purpose**: Handles all form operations directly
   - **Origin**: Core Function App hostname
   - **Health Probe**: `HEAD /`
   - **Caching**: Disabled (Function App controls headers)

3. **APIM Origin Group** (Configured but unused)
   - **Purpose**: Reserved for future file operations
   - **Origin**: Current APIM gateway
   - **Status**: Not actively used due to routing priority

#### CDN Routes (Current)
```terraform
# 1. Static assets (highest priority)
/assets/* → Storage Account Static Website
/public/* → Storage Account Static Website

# 2. Form operations (catch-all - currently active)
/* → Core Function App (Direct)
```

### 🔄 Planned Implementation

#### Future CDN Routes
```terraform
# 1. Static assets (unchanged)
/assets/* → Storage Account Static Website
/public/* → Storage Account Static Website

# 2. File operations (new dedicated APIM)
/services/* → Dedicated APIM → KFD Delete Function App
/upload/* → Dedicated APIM → KFD Upload Function App
/kfd-upload/* → Dedicated APIM → KFD Upload Function App

# 3. Form operations (catch-all)
/* → Core Function App (Direct)
```

## 🛠️ Implementation Details

### Current CDN Configuration

#### Route Priority & Matching
```
1. /assets/*     → Storage Account (Static)     ✅ Working
2. /public/*     → Storage Account (Static)     ✅ Working
3. /*            → Core Function App (Forms)    ✅ Working
```

#### Function App Internal Routing
The Core Function App handles internal routing logic:
- **Root requests** (`/`) → Form rendering
- **Form-specific** (`/{form_id}`) → Display form or redirect to not-found
- **Form submissions** (`POST /`) → Process and respond
- **Missing forms** → Redirect to `/form/not-found`

### Planned File Operations Setup

#### Dedicated APIM Features
When the separate APIM is implemented, it will provide:
- **Rate Limiting**: Control upload/delete frequency
- **Authentication**: API key or OAuth validation
- **Request Transformation**: Format requests for Function Apps
- **Response Management**: Standardized JSON responses
- **Monitoring**: Detailed API analytics

#### Function App Integration
- **KFD Upload Function App**: Handles file upload operations
- **KFD Delete Function App**: Handles file deletion operations
- **Secure Communication**: Function keys managed via APIM backend configuration

## 🧪 Testing Current Implementation

### Working Endpoints
```bash
# Replace with your actual CDN endpoint
CDN_URL="https://kainoscore-api-dev-dzhbbth7fqfjh0eb.a03.azurefd.net"

# ✅ Form operations (working)
curl $CDN_URL/                    # Root form rendering
curl $CDN_URL/test-form-id        # Form-specific request (redirects if not found)
curl -X POST $CDN_URL/            # Form submission

# ✅ Static assets (working)
curl $CDN_URL/assets/image.png    # Static content
curl $CDN_URL/public/style.css    # Public assets

# 🔄 File operations (future implementation)
curl -X PUT $CDN_URL/upload/file      # Will route to dedicated APIM
curl -X DELETE $CDN_URL/services/123  # Will route to dedicated APIM
```

### Validation Commands
```bash
# Check CDN endpoint is accessible
curl -I $CDN_URL/

# Verify form routing and redirects
curl -v $CDN_URL/nonexistent-form-id

# Test static asset caching
curl -I $CDN_URL/assets/test.png

# Check Function App direct access (for comparison)
FUNCTION_URL=$(terraform output -raw core_function_app_url)
curl $FUNCTION_URL/
```

## 📈 Performance Benefits

### Current Architecture Advantages

1. **Optimal Form Performance**
   - Direct CDN → Function App routing
   - No APIM overhead for form operations
   - Function App controls caching headers

2. **Efficient Static Asset Delivery**
   - CDN edge caching with 1-day TTL
   - Compression enabled
   - Global distribution

3. **Scalable File Operations** (Future)
   - API management features for uploads/deletes
   - Rate limiting and authentication
   - Monitoring and analytics

## 🔧 Deployment Considerations

### Infrastructure Dependencies
1. **Storage Account**: Static website hosting enabled
2. **Function Apps**: Core app for forms, separate apps for file operations
3. **CDN Profile**: Front Door Standard tier
4. **APIM**: Current instance (unused), future dedicated instance

### Environment Configuration
```bash
# Deploy infrastructure in order:
cd azure/
make plan global && make apply global    # Global resources
make plan rbac && make apply rbac        # RBAC assignments
make plan dev && make apply dev          # Environment-specific resources
```

### Monitoring & Troubleshooting
```bash
# Check CDN endpoint health
curl -I https://your-cdn-endpoint.azurefd.net/

# Monitor Function App logs
az webapp log tail --name your-function-app --resource-group your-rg

# Verify static website hosting
az storage blob service-properties show --account-name your-storage --query "staticWebsite"
```

## 🚀 Migration Strategy

### Phase 1: ✅ Completed
- CDN routing for forms and static content
- Core Function App handling form logic
- Storage Account serving static assets
- Form operations fully functional via CDN

### Phase 2: 🔄 In Planning (File Operations)
- Create dedicated APIM instance for file operations
- Implement KFD Upload and Delete Function Apps
- Update CDN routing rules for file operation paths
- Test upload/delete functionality

### Phase 3: 🎯 Future Optimization
- Performance monitoring and tuning
- Security hardening
- Custom domain configuration
- Advanced caching strategies

## 📝 Benefits Summary

| Aspect | Current Implementation | Benefits |
|--------|----------------------|----------|
| **Form Operations** | CDN → Function App (Direct) | ⚡ Optimal performance, no APIM overhead |
| **Static Assets** | CDN → Storage Account | 🚀 Aggressive caching, global distribution |
| **File Operations** | Future: CDN → Dedicated APIM | 🛡️ API management, rate limiting, auth |
| **Architecture** | Hybrid routing strategy | 🎯 Best of both worlds |
| **Management** | Single CDN endpoint | 🔧 Simplified client configuration |

This architecture provides the optimal balance of performance for forms, efficient static content delivery, and comprehensive API management for file operations when needed.
