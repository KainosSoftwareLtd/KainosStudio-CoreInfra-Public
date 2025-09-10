# Azure Infrastructure

This directory contains Terraform configurations for deploying Azure infrastructure that mirrors the AWS setup, providing feature parity with modern cloud best practices.

## 📚 Documentation

All detailed documentation is located in the `/docs` directory:

- **[Custom Domain Setup](../docs/custom-domain-setup.md)** - CDN and custom domain configuration
- **[Azure-AWS Endpoint Mapping](../docs/AWS_AZURE_ENDPOINT_MAPPING.md)** - Service equivalency mapping
- **[Blob Deployment Guide](../docs/BLOB_DEPLOYMENT.md)** - Function deployment via blob storage
- **[CDN Architecture Analysis](../docs/CDN_ARCHITECTURE_ANALYSIS.md)** - Content delivery network setup
- **[KFD Services Implementation](../docs/KFD_SERVICES_IMPLEMENTATION.md)** - Key services architecture
- **[Makefile Usage Guide](../docs/MAKEFILE_USAGE.md)** - Build and deployment automation
- **[Modular API Architecture](../docs/MODULAR_API_ARCHITECTURE.md)** - API Management patterns
- **[Publisher Variables Template](../docs/PUBLISHER_VARIABLES_TEMPLATE.md)** - Configuration templates
- **[Security Best Practices](../docs/SECURITY_BEST_PRACTICES.md)** - Security guidelines and audit results
- **[Security Audit Summary](../docs/SECURITY_AUDIT_SUMMARY.md)** - Latest security review
- **[Testing Guide](../docs/TESTING.md)** - Comprehensive testing procedures
- **[Unified Domain Architecture](../docs/UNIFIED_DOMAIN_ARCHITECTURE.md)** - Domain routing and SSL setup

## 🏗️ Architecture Overview

The Azure infrastructure is organized into three environments:

- **`global/`** - Shared resources (Key Vault, storage, service principals)
- **`rbac/`** - Role-based access control and permissions  
- **`dev/`** - Development environment (Function Apps, API Management, CDN, Cosmos DB)
- **`scripts/`** - Deployment and utility scripts (authentication, validation, testing)

## 🚀 Quick Start

### 1. Prerequisites Setup
```bash
# Install Azure CLI
brew install azure-cli  # macOS
# or visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

# Install Terraform
brew install terraform  # macOS
# or visit: https://terraform.io

# Configure Azure authentication
./scripts/setup-azure-auth.sh

# Or manually configure authentication:
az login
az account set --subscription "YOUR_SUBSCRIPTION_NAME"
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
```

### 2. Deploy Infrastructure (in order)
```bash
# Method 1: Using Makefile (Recommended - works from azure/ directory)
make plan global && make apply global    # Deploy global resources
make plan rbac && make apply rbac        # Deploy RBAC
make plan dev && make apply dev          # Deploy dev environment

# Method 2: Direct Terraform commands
cd global && terraform init && terraform apply
cd ../rbac && terraform init && terraform apply
cd ../dev && terraform init && terraform apply
```

### 3. Deploy Function Apps (Optional)
See [BLOB_DEPLOYMENT.md](./BLOB_DEPLOYMENT.md) for Function App deployment using blob storage.

### 4. Quick Commands Reference
```bash
# Complete deployment from scratch
./scripts/validate-all.sh                     # Validate first
make plan global && make apply global         # Step 1: Global resources
make plan rbac && make apply rbac             # Step 2: RBAC
make plan dev && make apply dev               # Step 3: Dev environment
./scripts/test-deployment.sh                  # Test deployment

# Individual operations
make validate dev                             # Validate environment
make checkov dev                              # Security scan
make plan dev                                 # Plan changes
make apply dev                                # Apply changes
```

## 📁 Directory Structure

```
azure/
├── global/                 # Global shared resources
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
├── rbac/                   # Role assignments and permissions
│   ├── main.tf
│   ├── variables.tf
│   └── ...
├── dev/                    # Development environment
│   ├── main.tf
│   ├── variables.tf
│   ├── azure-functions.tf
│   ├── api.tf
│   ├── cdn.tf
│   ├── network.tf
│   └── ...
├── modules/                # Reusable Terraform modules
│   ├── function-app/       # Azure Function App module
│   ├── api-management-service/  # Base API Management service
│   ├── network/            # Virtual Network module
│   ├── storage/            # Storage Account module
│   ├── cdn/               # Azure CDN module
│   └── ...
├── scripts/               # Deployment and utility scripts
│   ├── setup-azure-auth.sh      # Azure CLI authentication setup
│   ├── generate-function-urls.sh # Generate SAS URLs for function packages
│   ├── deploy-function-blob.sh   # Deploy functions from blob storage
│   ├── test-deployment.sh        # End-to-end testing
│   └── validate-all.sh           # Infrastructure validation
├── Makefile               # Build automation
└── README.md             # This file
```

## 📚 Documentation

All documentation has been organized in the main `docs/` folder:

- **[docs/BLOB_DEPLOYMENT.md](../docs/BLOB_DEPLOYMENT.md)** - Function App blob storage deployment guide
- **[docs/custom-domain-setup.md](../docs/custom-domain-setup.md)** - Custom domain setup for CDN
- **[docs/UNIFIED_DOMAIN_ARCHITECTURE.md](../docs/UNIFIED_DOMAIN_ARCHITECTURE.md)** - Unified domain routing architecture
- **[docs/MODULAR_API_ARCHITECTURE.md](../docs/MODULAR_API_ARCHITECTURE.md)** - Modular API deployment guide
- **[docs/CDN_ARCHITECTURE_ANALYSIS.md](../docs/CDN_ARCHITECTURE_ANALYSIS.md)** - CDN architecture analysis
- **[docs/KFD_SERVICES_IMPLEMENTATION.md](../docs/KFD_SERVICES_IMPLEMENTATION.md)** - KFD services implementation
- **[docs/TESTING.md](../docs/TESTING.md)** - Comprehensive testing guide
- **[docs/MAKEFILE_USAGE.md](../docs/MAKEFILE_USAGE.md)** - Build automation guide
- **[docs/AWS_AZURE_ENDPOINT_MAPPING.md](../docs/AWS_AZURE_ENDPOINT_MAPPING.md)** - AWS to Azure endpoint mapping

## 🛠️ Utility Scripts

The `scripts/` folder contains automation tools for deployment and management:

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-azure-auth.sh` | Azure CLI authentication and validation | `./scripts/setup-azure-auth.sh` |
| `generate-function-urls.sh` | Generate SAS URLs for function packages | `./scripts/generate-function-urls.sh` |
| `deploy-function-blob.sh` | Deploy function apps from blob storage | `./scripts/deploy-function-blob.sh` |
| `deploy-apim-service.sh` | Deploy API Management service independently | `./scripts/deploy-apim-service.sh dev plan` |
| `deploy-core-api.sh` | Deploy Core API independently | `./scripts/deploy-core-api.sh dev apply` |
| `deploy-kfd-api.sh` | Deploy KFD Services API independently | `./scripts/deploy-kfd-api.sh dev apply` |
| `test-deployment.sh` | End-to-end API and endpoint testing | `./scripts/test-deployment.sh` |
| `validate-all.sh` | Validate all environment configurations | `./scripts/validate-all.sh` |

For detailed information about each script, see [scripts/README.md](scripts/README.md).

## 🔧 Available Commands

```bash
# Validate all environments
make validate <env>        # dev, global, rbac
make validate-all          # All environments

# Format code
make fmt <env>

# Security scan
make checkov <env>

# Plan deployment
make plan <env>

# Deploy infrastructure
make apply <env>

# Complete deployment workflow
make plan global && make apply global    # 1. Deploy global resources
make plan rbac && make apply rbac        # 2. Deploy RBAC
make plan dev && make apply dev          # 3. Deploy dev environment

# Run tests
./scripts/test-deployment.sh      # End-to-end testing
./scripts/validate-all.sh         # Quick validation
```

## 🔧 Modular API Deployment

The infrastructure supports **independent deployment of each API** for better change management:

### Traditional Full Deployment
```bash
make init dev && make plan dev && make apply dev
```

### Modular API Deployment (Recommended)
```bash
# 1. Deploy base API Management service
make deploy-apim-service dev plan
make deploy-apim-service dev apply

# 2. Deploy Core API independently
make deploy-core-api dev plan
make deploy-core-api dev apply

# 3. Deploy KFD Services API independently
make deploy-kfd-api dev plan
make deploy-kfd-api dev apply
```

### Benefits of Modular Approach
- ✅ **Faster deployments** - Only deploy what changed
- ✅ **Independent rollbacks** - Rollback individual APIs
- ✅ **Reduced risk** - Changes don't affect other APIs
- ✅ **Better CI/CD** - Separate pipelines per API

See [MODULAR_API_ARCHITECTURE.md](../docs/MODULAR_API_ARCHITECTURE.md) for complete details.

## 🔐 Authentication Setup

### Method 1: Automated Setup (Recommended)
```bash
./scripts/setup-azure-auth.sh
```

### Method 2: Manual Setup
```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "YOUR_SUBSCRIPTION_NAME"

# Export subscription ID for Terraform (Required)
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Verify access
az account show
```

### Required Environment Variables

For Terraform to authenticate properly with Azure, you **must** set the following environment variable:

```bash
# Set the ARM_SUBSCRIPTION_ID environment variable
export ARM_SUBSCRIPTION_ID="your-subscription-id-here"

# Alternative: Get from Azure CLI automatically
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
```

**Important**: This environment variable is required for all Terraform operations. Without it, you may encounter authentication errors.

### Verification

Verify your authentication setup:
```bash
# Check Azure CLI authentication
az account show

# Verify environment variable is set
echo $ARM_SUBSCRIPTION_ID

# Test Terraform authentication
cd dev && terraform init && terraform plan
```

## ⚙️ Configuration

### API Management Publisher Settings
Configure organization details in your environment's `terraform.tfvars`:

```hcl
# API Management Configuration
api_management_publisher_name  = "Your Organization"
api_management_publisher_email = "admin@yourorg.com"
```

**Available Variables:**
- `api_management_publisher_name` - Organization name displayed in API Management
- `api_management_publisher_email` - Contact email for API Management
- `api_management_sku` - SKU tier (Developer_1, Basic_1, Standard_1, Premium_1)

For new environments, see [docs/PUBLISHER_VARIABLES_TEMPLATE.md](../docs/PUBLISHER_VARIABLES_TEMPLATE.md) for setup guidance.

## 🏭 Environments

### Global Environment (`global/`)
**Purpose**: Shared resources used across all environments

**Resources**:
- Resource Groups (dev, staging, prod)
- Azure Key Vault (secrets management)
- Log Analytics Workspace (monitoring)
- Application Insights (telemetry)
- Storage Accounts (Terraform state, shared artifacts)
- Service Principal (GitHub Actions)

**Deploy**: Always deploy first

### RBAC Environment (`rbac/`)
**Purpose**: Role-based access control and permissions

**Resources**:
- Custom role definitions
- Role assignments for GitHub Actions
- Managed identity permissions
- Function App access policies

**Dependencies**: Requires `global` environment

### Dev Environment (`dev/`)
**Purpose**: Development application resources

**Resources**:
- Azure Function Apps (3x: Core, KFD Upload, KFD Delete)
- Azure CDN (unified routing + static content)
- Cosmos DB (NoSQL database)
- Storage Accounts (multiple for different purposes with static website hosting)
- Virtual Network (supporting infrastructure)

**Dependencies**: Requires `global` and `rbac` environments

## 🆚 AWS Parity

| Component | AWS | Azure | Status |
|-----------|-----|-------|--------|
| Compute | Lambda | Function Apps | ✅ Complete |
| Unified Domain | CloudFront + API Gateway | Azure CDN | ✅ Complete |
| CDN | CloudFront | Azure CDN | ✅ Complete |
| Database | DynamoDB | Cosmos DB | ✅ Complete |
| Storage | S3 | Blob Storage + Static Website | ✅ Complete |
| Secrets | Secrets Manager | Key Vault | ✅ Complete |
| Monitoring | CloudWatch | Log Analytics | ✅ Complete |
| IAM | IAM Roles | RBAC + Managed Identity | ✅ Complete |
| Networking | VPC | Virtual Network | ✅ Complete |

### 🔗 API Endpoint Parity

Azure API Management now provides **full endpoint compatibility** with AWS API Gateway KFD services:

| AWS Endpoint | Azure Endpoint | Method | Purpose |
|--------------|----------------|--------|---------|
| `PUT /` | `PUT /` | PUT | Upload files |
| `DELETE /services/{id}` | `DELETE /services/{id}` | DELETE | Delete files by ID |

**Traditional Azure endpoints remain available** for backward compatibility:
- `POST /kfd-upload/upload` - Upload files
- `DELETE /kfd-delete/delete/*` - Delete files

## 📊 Features

### Function Apps
- **Blob Storage Deployment**: Similar to Lambda S3 deployment
- **Managed Identity**: Secure access to Azure resources
- **Application Insights**: Built-in monitoring and logging
- **Auto-scaling**: Consumption-based scaling

### API Management
- **Modular Architecture**: Separate deployment of each API
- **Base Service**: API Management infrastructure only
- **Independent APIs**: Core API and KFD Services API deployed separately
- **AWS-Compatible KFD Services**: `PUT /` and `DELETE /services/{id}` endpoints
- **Traditional Endpoints**: Core API, Upload/Delete functions
- **Request/Response Transformation**: Policy-based processing
- **CORS Support**: Cross-origin resource sharing
- **Rate Limiting**: Built-in throttling
- **Function Key Authentication**: Secure backend access

### Azure CDN
- **API Caching**: Caches API Management responses
- **Static Content**: Optional static file distribution
- **Custom Domains**: Production domain support
- **SSL/TLS**: Automatic certificate management

### Security
- **Key Vault Integration**: Centralized secret management
- **Managed Identity**: No credential management needed
- **RBAC**: Fine-grained access control
- **Private Endpoints**: Network isolation (optional)
- **SSL/TLS**: End-to-end encryption support

## 🧪 Testing & Validation

### Pre-deployment Validation
```bash
./scripts/validate-all.sh          # Quick validation
make validate dev           # Single environment
make checkov dev           # Security scan
```

### Post-deployment Testing
```bash
./scripts/test-deployment.sh       # End-to-end API testing
```

### Manual Testing
```bash
# Test Function Apps directly
curl https://your-function-app.azurewebsites.net/api/health

# Test via API Management
curl https://your-apim.azure-api.net/core/health

# Test via CDN
curl https://your-cdn.azureedge.net/core/health
```

## 📚 Documentation

- [BLOB_DEPLOYMENT.md](./BLOB_DEPLOYMENT.md) - Function App blob storage deployment
- [TESTING.md](./TESTING.md) - Comprehensive testing guide
- [MAKEFILE_USAGE.md](./MAKEFILE_USAGE.md) - Build automation guide

## 🆘 Troubleshooting

### Common Issues

**Authentication Errors**
```bash
# Re-authenticate with Azure CLI
az login
az account set --subscription "YOUR_SUBSCRIPTION"

# Set required environment variable
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Verify environment variable is set
echo $ARM_SUBSCRIPTION_ID
```

**Permission Errors**
```bash
# Check your role assignments
az role assignment list --assignee $(az account show --query user.name --output tsv) --output table
```

**Terraform State Issues**
```bash
# Verify backend access
az storage account show --name kainoscoreterraformsa --resource-group kainoscore-terraform-rg
```

### Getting Help

1. Check the error logs in Azure Portal
2. Verify authentication: `az account show`
3. Run validation: `./scripts/validate-all.sh`
4. Check resource dependencies
5. Review Terraform state: `terraform state list`

## 🔄 CI/CD Integration

This infrastructure is designed for automated deployment via GitHub Actions or Azure DevOps. See the individual environment README files for pipeline examples.

## 🏷️ Version Information

- **Terraform**: >= 1.10.0
- **Azure Provider**: ~> 4.38.1
- **Azure CLI**: Latest stable
- **Architecture**: Multi-environment, modular, production-ready
