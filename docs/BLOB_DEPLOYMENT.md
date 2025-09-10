# Azure Function App Blob Storage Deployment Guide

## Overview

Your Azure Function Apps are now configured to deploy from blob storage packages, similar to AWS Lambda deployment from S3. This provides better version control, larger package support, and a more robust deployment pipeline.

## � Prerequisites: Azure CLI Setup & Authentication

### 1. Install Azure CLI
```bash
# macOS
brew install azure-cli

# Windows (using winget)
winget install Microsoft.AzureCLI

# Linux (Ubuntu/Debian)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 2. Login to Azure
```bash
# Interactive login (opens browser)
az login

# Login with specific tenant (if you have multiple)
az login --tenant YOUR_TENANT_ID

# Login for CI/CD (service principal)
az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
```

### 3. Set Default Subscription
```bash
# List available subscriptions
az account list --output table

# Set default subscription
az account set --subscription "SUBSCRIPTION_NAME_OR_ID"

# Verify current subscription
az account show --output table
```

### 4. Configure Terraform Backend Access
```bash
# Ensure you have access to the Terraform state storage
az storage account show \
  --name kainoscoreterraformsa \
  --resource-group kainoscore-terraform-rg \
  --output table

# Test access to deployment container
az storage container show \
  --account-name kainoscoreterraformsa \
  --name deployment-packages \
  --auth-mode login
```

### 5. Verify Required Permissions
```bash
# Check your role assignments
az role assignment list \
  --assignee $(az account show --query user.name --output tsv) \
  --output table

# Required roles for this deployment:
# - Contributor (on subscription or resource groups)
# - Storage Blob Data Contributor (on storage accounts)
# - Key Vault Contributor (on key vaults)
```

### 6. Configure Terraform Authentication
Terraform will automatically use Azure CLI authentication. Verify with:
```bash
# Test Terraform can authenticate
cd azure/dev
terraform init
terraform plan -refresh-only
```

## �🚀 Quick Start

### 1. Package Your Function Code
```bash
# Example: Package your Node.js function
cd /path/to/your/function-code
zip -r core-function.zip . -x "node_modules/*" "*.git*"
```

### 2. Upload to Blob Storage
```bash
# Upload function packages to the deployment container
az storage blob upload \
  --account-name kainoscoreterraformsa \
  --container-name deployment-packages \
  --name functions/core-function-latest.zip \
  --file core-function.zip \
  --auth-mode login

# Repeat for other functions
az storage blob upload \
  --account-name kainoscoreterraformsa \
  --container-name deployment-packages \
  --name functions/kfd-upload-function-latest.zip \
  --file kfd-upload-function.zip \
  --auth-mode login

az storage blob upload \
  --account-name kainoscoreterraformsa \
  --container-name deployment-packages \
  --name functions/kfd-delete-function-latest.zip \
  --file kfd-delete-function.zip \
  --auth-mode login
```

### 3. Generate SAS URLs
```bash
# Generate secure URLs for terraform.tfvars
./scripts/generate-function-urls.sh
```

### 4. Update terraform.tfvars
Copy the generated URLs to your `dev/terraform.tfvars` file:
```hcl
# Function App Deployment Package URLs (Blob Storage with SAS tokens)
core_function_package_url       = "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/core-function-latest.zip?sp=r&st=..."
kfd_upload_function_package_url = "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/kfd-upload-function-latest.zip?sp=r&st=..."
kfd_delete_function_package_url = "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/kfd-delete-function-latest.zip?sp=r&st=..."
```

### 5. Deploy Infrastructure
```bash
# Method 1: Using Makefile (Recommended - from azure/ directory)
cd azure
make plan dev && make apply dev

# Method 2: Direct Terraform commands
cd azure/dev
terraform plan -out=deployment.tfplan
terraform apply deployment.tfplan
```

## 📁 File Structure

Your function packages should follow this structure:
```
functions/
├── core-function-latest.zip
├── kfd-upload-function-latest.zip
├── kfd-delete-function-latest.zip
├── core-function-20250804-123456.zip    # Versioned backups
├── kfd-upload-function-20250804-123456.zip
└── kfd-delete-function-20250804-123456.zip
```

## 🔄 Deployment Workflow

### Development Deployment
```bash
# 1. Package function
zip -r function.zip src/

# 2. Upload with timestamp (for versioning)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
az storage blob upload \
  --account-name kainoscoreterraformsa \
  --container-name deployment-packages \
  --name "functions/core-function-$TIMESTAMP.zip" \
  --file function.zip

# 3. Copy to latest (for easy deployment)
az storage blob copy start \
  --account-name kainoscoreterraformsa \
  --destination-blob "functions/core-function-latest.zip" \
  --destination-container deployment-packages \
  --source-uri "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/core-function-$TIMESTAMP.zip"

# 4. Generate new SAS URLs and update terraform.tfvars
./scripts/generate-function-urls.sh

# 5. Deploy (from azure/ directory)
make apply dev
```

### CI/CD Pipeline Integration
```yaml
# Example GitHub Actions workflow
steps:
  - name: Build Function App
    run: |
      cd function-app
      npm install --production
      zip -r ../function.zip .

  - name: Upload to Blob Storage
    run: |
      az storage blob upload \
        --account-name kainoscoreterraformsa \
        --container-name deployment-packages \
        --name "functions/core-function-${{ github.sha }}.zip" \
        --file function.zip

      # Update latest
      az storage blob copy start \
        --account-name kainoscoreterraformsa \
        --destination-blob "functions/core-function-latest.zip" \
        --destination-container deployment-packages \
        --source-uri "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/core-function-${{ github.sha }}.zip"

  - name: Generate SAS URLs
    run: |
      ./azure/scripts/generate-function-urls.sh > function-urls.txt

  - name: Update Terraform
    run: |
      # Update terraform.tfvars with new URLs
      # Run terraform apply
```

## 🔧 Configuration Details

### Variables Added
- `core_function_package_url`: URL for Core Function App package
- `kfd_upload_function_package_url`: URL for KFD Upload Function App package
- `kfd_delete_function_package_url`: URL for KFD Delete Function App package
- `enable_function_blob_deployment`: Toggle for blob deployment (default: true)

### Deployment Settings
Each Function App is configured with:
- `WEBSITE_RUN_FROM_PACKAGE`: Set to the blob URL with SAS token
- `SCM_DO_BUILD_DURING_DEPLOYMENT`: Set to false (packages are pre-built)
- `WEBSITE_ENABLE_SYNC_UPDATE_SITE`: Enables automatic updates when package changes

## 🔒 Security Features

- **SAS Tokens**: Time-limited access to blob storage (7 days expiry)
- **HTTPS Only**: All blob URLs use HTTPS
- **Managed Identity**: Function Apps use managed identity for Azure resource access
- **Key Vault Integration**: Secrets stored in Azure Key Vault

## 🆚 Comparison with AWS Lambda

| Feature | AWS Lambda + S3 | Azure Functions + Blob | Status |
|---------|-----------------|------------------------|---------|
| Package Storage | S3 Bucket | Blob Container | ✅ Configured |
| Deployment Method | update-function-code | WEBSITE_RUN_FROM_PACKAGE | ✅ Implemented |
| Security | IAM roles | SAS tokens + Managed Identity | ✅ Secured |
| Versioning | S3 versions | Blob naming + snapshots | ✅ Supported |
| Size Limits | 250MB from S3 | Unlimited from blob | ✅ Better |
| CI/CD Ready | Native support | Custom scripts | ✅ Provided |

## 🚨 Troubleshooting

### Authentication Issues

**Problem: "az login" doesn't work**
```bash
# Clear Azure CLI cache and try again
az logout
az cache purge
az login

# Login with specific tenant if you have multiple
az login --tenant YOUR_TENANT_ID
```

**Problem: "Error: building AzureRM Client: obtain subscription"**
```bash
# Check if you're logged in
az account show

# Set the correct subscription
az account set --subscription "YOUR_SUBSCRIPTION_NAME"

# Verify Terraform can access Azure
cd azure/dev && terraform plan -refresh-only
```

**Problem: "StorageAccountNotFound" or permission errors**
```bash
# Verify you have access to the storage account
az storage account show \
  --name kainoscoreterraformsa \
  --resource-group kainoscore-terraform-rg

# Check your role assignments
az role assignment list --assignee $(az account show --query user.name --output tsv) --output table
```

**Problem: Multiple Azure accounts/tenants**
```bash
# List all accounts
az account list --output table

# Login to specific tenant
az login --tenant TENANT_ID

# Switch between accounts
az account set --subscription "SUBSCRIPTION_NAME"
```

### Function App Deployment Issues

**Package Not Deploying**
1. Check SAS URL is valid and not expired
2. Verify blob exists in storage account
3. Ensure Function App has access to storage account
4. Check Application Insights logs for errors

### Generate New SAS URLs
```bash
./scripts/generate-function-urls.sh
# Copy output to terraform.tfvars
make apply dev  # or use: terraform apply
```

### Rollback to Previous Version
```bash
# Copy a previous version to latest
az storage blob copy start \
  --account-name kainoscoreterraformsa \
  --destination-blob "functions/core-function-latest.zip" \
  --destination-container deployment-packages \
  --source-uri "https://kainoscoreterraformsa.blob.core.windows.net/deployment-packages/functions/core-function-20250804-123456.zip"

# Regenerate URLs and deploy
./scripts/generate-function-urls.sh
make apply dev  # or use: terraform apply
```

### Quick Setup Script
Run the automated setup script to configure everything:
```bash
# Run comprehensive Azure CLI setup and validation
./scripts/setup-azure-auth.sh
```

## 📞 Support

For issues with blob deployment:
1. Check the deployment logs in Azure portal
2. Verify SAS token permissions and expiry
3. Ensure blob storage connectivity
4. Review Function App configuration in Azure portal
