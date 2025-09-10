# Azure Deployment Scripts

This folder contains utility scripts for Azure infrastructure deployment and management.

## 📁 Script Overview

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-azure-auth.sh` | Azure CLI authentication setup and validation | `./setup-azure-auth.sh` |
| `azure-check.sh` | Check Azure CLI installation, environment variables, and login status | `./azure-check.sh` |
| `generate-function-urls.sh` | Generate SAS URLs for function app blob packages | `./generate-function-urls.sh` |
| `deploy-function-blob.sh` | Deploy function apps from blob storage | `./deploy-function-blob.sh` |
| `test-deployment.sh` | Test deployed infrastructure endpoints | `./test-deployment.sh` |
| `validate-all.sh` | Validate all environment configurations | `./validate-all.sh` |

## 🚀 Quick Start

### 1. Azure Environment Check
```bash
# Check Azure CLI installation, environment variables, and login status
./scripts/azure-check.sh
```

### 2. Azure Authentication Setup
```bash
# Set up Azure CLI authentication and validate permissions
./scripts/setup-azure-auth.sh
```

### 3. Function App Deployment
```bash
# Generate SAS URLs for function packages
./scripts/generate-function-urls.sh

# Deploy function apps from blob storage
./scripts/deploy-function-blob.sh
```

### 4. Infrastructure Testing
```bash
# Test all deployed endpoints
./scripts/test-deployment.sh

# Validate all environment configurations
./scripts/validate-all.sh
```

## 📋 Script Details

### setup-azure-auth.sh
- **Purpose**: Automates Azure CLI login, subscription selection, and permission validation
- **Prerequisites**: Azure CLI installed
- **Output**: Validates authentication and required permissions
- **Usage**: Run once before deployment

### azure-check.sh
- **Purpose**: Comprehensive Azure environment validation and diagnostics
- **Prerequisites**: None (checks if Azure CLI is installed)
- **Output**: Azure CLI version, environment variables, login status, and available subscriptions
- **Usage**: Run this script first to validate your Azure environment before proceeding with authentication setup
- **Features**:
  - Verifies Azure CLI installation and version
  - Displays all Azure-related environment variables (ARM_* and AZURE_*)
  - Shows current login status and active account details
  - Lists all available subscriptions
  - Provides quick reference commands for common Azure CLI operations

### generate-function-urls.sh
- **Purpose**: Generates time-limited SAS URLs for function app packages
- **Prerequisites**: Azure CLI authenticated, blob packages uploaded
- **Output**: SAS URLs for terraform.tfvars
- **Usage**: Run whenever function packages are updated

### deploy-function-blob.sh
- **Purpose**: Comprehensive function app deployment from blob storage
- **Prerequisites**: Authentication setup, SAS URLs generated
- **Output**: Deployed function apps with blob package sources
- **Usage**: Primary deployment script

### test-deployment.sh
- **Purpose**: Tests deployed infrastructure endpoints and functionality
- **Prerequisites**: Infrastructure deployed successfully
- **Output**: Health check results and endpoint validation
- **Usage**: Run after deployment to verify functionality

### validate-all.sh
- **Purpose**: Validates Terraform configurations across all environments
- **Prerequisites**: Terraform configurations present
- **Output**: Validation results for dev, staging, production
- **Usage**: Run before deployment to catch configuration issues

## 🔧 Configuration

### Environment Variables
Some scripts may use these environment variables:
```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export STORAGE_ACCOUNT_NAME="kainoscoreterraformsa"
export CONTAINER_NAME="deployment-packages"
```

### Script Permissions
Ensure scripts are executable:
```bash
chmod +x scripts/*.sh
```

## 🔄 CI/CD Integration

These scripts can be integrated into CI/CD pipelines:

```yaml
# GitHub Actions example
steps:
  - name: Setup Azure Auth
    run: ./azure/scripts/setup-azure-auth.sh

  - name: Generate Function URLs
    run: ./azure/scripts/generate-function-urls.sh > function-urls.txt

  - name: Deploy Infrastructure
    run: ./azure/scripts/deploy-function-blob.sh

  - name: Test Deployment
    run: ./azure/scripts/test-deployment.sh
```

## 🚨 Troubleshooting

### Permission Issues
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Check Azure CLI authentication
az account show
```

### Script Failures
1. Check Azure CLI authentication: `az account show`
2. Verify subscription access: `az account list`
3. Confirm storage account access: `az storage account show --name kainoscoreterraformsa`
4. Review script output for specific error messages

### Common Solutions
- **Authentication expired**: Re-run `./scripts/setup-azure-auth.sh`
- **SAS URLs expired**: Re-run `./scripts/generate-function-urls.sh`
- **Permission denied**: Check file permissions with `ls -la scripts/`

For more detailed troubleshooting, see:
- [BLOB_DEPLOYMENT.md](../BLOB_DEPLOYMENT.md) - Blob deployment troubleshooting
- [TESTING.md](../TESTING.md) - Testing and validation issues
