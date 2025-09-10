# Modular API Management Architecture

## 🎯 Overview

The Azure infrastructure has been refactored from a monolithic API Management approach to a **modular, independently deployable API architecture**. This enables separate deployment and management of each API without creating dependencies between different services.

## 🏗️ Architecture Changes

### Before (Monolithic)
```
Single API Management Module
├── Core API
├── KFD Upload API
├── KFD Delete API
└── KFD Services API (AWS-compatible)
```
**Issues**:
- All APIs deployed together
- Single point of failure
- Cannot deploy APIs independently
- Tight coupling between different services

### After (Modular)
```
API Management Service (Base)
├── Infrastructure only
└── No APIs defined

Separate API Modules:
├── Core API Module (Independent)
├── KFD Services API Module (Independent - AWS Compatible)
└── Future APIs (Independent)
```
**Benefits**:
- ✅ Independent deployment of each API
- ✅ No coupling between different APIs
- ✅ Faster, targeted deployments
- ✅ Individual rollback capabilities
- ✅ Better change management

## 📁 Module Structure

### 1. API Management Service (`modules/api-management-service/`)
**Purpose**: Base API Management infrastructure only
- Azure API Management service
- Application Insights
- Global policies
- Managed identity
- Custom domain configuration

### 2. Core API (`modules/core-api/`)
**Purpose**: Main application API
- Core API definition (`/api/*`)
- Backend routing to Core Function App
- API policies and operations

### 3. KFD Services API (`modules/kfd-services-api/`)
**Purpose**: AWS-compatible KFD file operations
- Upload endpoint: `PUT /`
- Delete endpoint: `DELETE /services/{id}`
- Backend routing to KFD Function Apps
- AWS-compatible policies

## 🚀 Deployment Options

### Method 1: Using Make (Recommended)

#### Deploy Base API Management Service
```bash
# Plan deployment
make deploy-apim-service dev plan

# Apply deployment
make deploy-apim-service dev apply

# Destroy if needed
make deploy-apim-service dev destroy
```

#### Deploy Core API Independently
```bash
# Plan Core API deployment
make deploy-core-api dev plan

# Apply Core API deployment
make deploy-core-api dev apply

# Destroy Core API only
make deploy-core-api dev destroy
```

#### Deploy KFD Services API Independently
```bash
# Plan KFD Services API deployment
make deploy-kfd-api dev plan

# Apply KFD Services API deployment
make deploy-kfd-api dev apply

# Destroy KFD Services API only
make deploy-kfd-api dev destroy
```

### Method 2: Using Direct Scripts

```bash
# API Management Service
./scripts/deploy-apim-service.sh dev plan
./scripts/deploy-apim-service.sh dev apply

# Core API
./scripts/deploy-core-api.sh dev plan
./scripts/deploy-core-api.sh dev apply

# KFD Services API
./scripts/deploy-kfd-api.sh dev plan
./scripts/deploy-kfd-api.sh dev apply
```

### Method 3: Using Terraform Targets

```bash
# API Management Service only
terraform plan -target="module.api_management_service"
terraform apply -target="module.api_management_service"

# Core API only
terraform plan -target="module.core_api"
terraform apply -target="module.core_api"

# KFD Services API only
terraform plan -target="module.kfd_services_api"
terraform apply -target="module.kfd_services_api"
```

## 📋 Deployment Sequence

### Initial Setup (Recommended Order)
1. **Deploy base infrastructure** (Function Apps, Storage, etc.)
2. **Deploy API Management Service** (base infrastructure)
3. **Deploy APIs independently** as needed

```bash
# 1. Full infrastructure (traditional approach)
make init dev && make plan dev && make apply dev

# OR deploy step by step:

# 1. Deploy API Management Service first
make deploy-apim-service dev apply

# 2. Deploy Core API
make deploy-core-api dev apply

# 3. Deploy KFD Services API
make deploy-kfd-api dev apply
```

### Updating Individual APIs
```bash
# Update only Core API (no impact on KFD API)
make deploy-core-api dev plan
make deploy-core-api dev apply

# Update only KFD Services API (no impact on Core API)
make deploy-kfd-api dev plan
make deploy-kfd-api dev apply
```

## 🔄 Migration from Monolithic

If you have an existing monolithic API Management deployment:

1. **Import existing state** (optional, for advanced users):
   ```bash
   # Import API Management service
   terraform import module.api_management_service.azurerm_api_management.apim /subscriptions/.../resourceGroups/.../providers/Microsoft.ApiManagement/service/your-apim
   ```

2. **Deploy individual APIs**:
   ```bash
   make deploy-core-api dev apply
   make deploy-kfd-api dev apply
   ```

3. **Remove old module references** from your terraform state if needed

## 🎛️ Configuration

### Environment Variables
Each API module uses the same environment variables as before:
- `core_function_url`, `core_function_key`
- `kfd_upload_function_url`, `kfd_upload_function_key`
- `kfd_delete_function_url`, `kfd_delete_function_key`

### Dependencies
- **API Management Service**: No dependencies on Function Apps
- **Core API**: Depends on API Management Service + Core Function App
- **KFD Services API**: Depends on API Management Service + KFD Function Apps

## 🧪 Testing Individual APIs

### Test Core API
```bash
curl https://your-apim.azure-api.net/api/health
```

### Test KFD Services API (AWS-Compatible)
```bash
# Upload file
curl -X PUT "https://your-apim.azure-api.net/" \
  -H "Content-Type: application/json" \
  -d '{"file": "data"}'

# Delete file
curl -X DELETE "https://your-apim.azure-api.net/services/file-123"
```

## 📊 Benefits Summary

| Aspect | Monolithic | Modular |
|--------|------------|---------|
| **Deployment Speed** | Slow (all APIs) | Fast (single API) |
| **Change Impact** | High (affects all) | Low (isolated) |
| **Rollback** | All or nothing | Per API |
| **Development** | Coupled | Independent |
| **Testing** | Complex | Isolated |
| **Maintenance** | Difficult | Simple |

## 🔧 Troubleshooting

### Common Issues

1. **API Management Service not found**
   ```bash
   # Deploy base service first
   make deploy-apim-service dev apply
   ```

2. **Function App not found**
   ```bash
   # Deploy function apps first
   make apply dev  # Full deployment
   ```

3. **Permission issues**
   ```bash
   # Check RBAC deployment
   make apply rbac
   ```

This modular approach provides much better separation of concerns and enables true independent API management! 🎉
