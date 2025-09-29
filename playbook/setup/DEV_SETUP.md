# Development Environment Setup Guide

This guide provides step-by-step instructions for setting up the Kainos Studio development environment.

## 🎯 Overview

The development environment is designed for:
- Feature development and testing
- Local debugging and validation
- Rapid iteration and experimentation
- Integration with local services

## 📋 Prerequisites

Ensure you have the following installed:
- **Terraform**: ~> 1.10.0 (use [tfenv](https://github.com/tfutils/tfenv) for version management)
- **Pre-commit**: For code quality hooks
- **Python**: Required for pre-commit installation
- **Node.js**: For serverless function development
- **Cloud CLI**: AWS CLI or Azure CLI with configured credentials

## 🚀 Setup Instructions

### 1. Clone and Navigate

```bash
git clone <repository-url>
cd KainosStudio-CoreInfra-Public
```

### 2. Choose Your Provider

#### For AWS Development
```bash
cd aws
```

#### For Azure Development
```bash
cd azure
```

### 3. Initialize Development Environment

```bash
make init dev
```

This command will:
- Initialize Terraform backend for dev environment
- Install pre-commit hooks
- Download required providers and modules

### 4. Configure Environment Variables

#### AWS Development (.env in aws/dev/lambdas/core/)
```env
COOKIE_SECRET='dev-cookie-secret-change-me'
SESSION_SECRET='dev-session-secret-change-me'
CLOUD_PROVIDER='aws'
BUCKET_NAME='kainos-core-kfd-files-dev'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='true'
LOG_LEVEL='debug'
BUCKET_NAME_FOR_FORM_FILES='kainos-core-form-files-dev'
BUCKET_REGION_FOR_FORM_FILES='eu-west-2'
FORM_SESSION_TABLE_NAME='Core_FormSessions_dev'
ALLOWED_ORIGIN='http://localhost:3000'
```

#### Azure Development (.env in azure/dev/functions/core/)
```env
COOKIE_SECRET='dev-cookie-secret-change-me'
SESSION_SECRET='dev-session-secret-change-me'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='true'
LOG_LEVEL='debug'
CLOUD_PROVIDER='azure'
AZURE_STORAGE_ACCOUNT='kainoscorestoragedev'
AZURE_STORAGE_CONTAINER='kfd-files'
AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES='kainosformfilesdev'
AZURE_STORAGE_CONTAINER_FOR_FORM_FILES='submitted-forms'
AZURE_COSMOS_ENDPOINT='https://kainos-core-cosmos-dev.documents.azure.com:443/'
AZURE_COSMOS_DATABASE='KainosCore'
FORM_SESSION_TABLE_NAME='FormSessions'
ALLOWED_ORIGIN='http://localhost:3000'
```

### 5. Plan Infrastructure Changes

```bash
make plan dev
```

Review the Terraform plan output to understand what resources will be created.

### 6. Apply Infrastructure

```bash
make apply dev
```

This will deploy the development infrastructure to your chosen cloud provider.

### 7. Validate Deployment

```bash
make check
```

This runs:
- Terraform format validation
- Configuration validation
- Security scanning with Checkov

## 🏗️ Infrastructure Components

### AWS Development Resources

Refer to [AWS Lambda Module](../../aws/modules/lambda/) and [AWS S3 Module](../../aws/modules/s3/) for detailed configuration options.

**Key Resources:**
- Lambda functions for core application and upload handling
- S3 buckets for KFD files and form submissions
- CloudWatch logs with 7-day retention
- IAM roles with least-privilege access
- KMS keys for encryption

### Azure Development Resources

Refer to [Azure Function App Module](../../azure/modules/function-app/) and [Azure Storage Module](../../azure/modules/storage/) for detailed configuration options.

**Key Resources:**
- Function Apps for core application and upload handling
- Storage Accounts for KFD files and form submissions
- Application Insights for monitoring
- Cosmos DB for session storage
- Key Vault for secrets management

## 🔧 Local Development

### Running Locally

```bash
# Navigate to function directory
cd dev/lambdas/core  # AWS
cd dev/functions/core  # Azure

# Install dependencies
npm install

# Start local development server
npm run dev
```

### Local Testing

```bash
# Run unit tests
npm test

# Run integration tests
npm run test:integration

# Run with coverage
npm run test:coverage
```

## 🔍 Troubleshooting

### Common Issues

1. **Terraform Backend Issues**
   ```bash
   # Reinitialize backend
   terraform init -reconfigure
   ```

2. **Permission Errors**
   - Verify cloud CLI credentials
   - Check IAM/RBAC permissions
   - Ensure correct region/subscription

3. **Function Deployment Failures**
   - Check function source code exists
   - Verify environment variables
   - Review CloudWatch/Application Insights logs

### Validation Commands

```bash
# Check Terraform configuration
terraform validate

# Format Terraform files
terraform fmt -recursive

# Run security scan
make checkov dev

# Check pre-commit hooks
pre-commit run --all-files
```

## 🔄 Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Modify Terraform configurations
   - Update function code
   - Add/update tests

3. **Validate Changes**
   ```bash
   make check
   make plan dev
   ```

4. **Test Locally**
   ```bash
   npm test
   npm run dev
   ```

5. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - GitHub Actions will run automated checks
   - Review Terraform plan output
   - Ensure all tests pass

## 📚 References

- **[Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)**
- **[Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)**
- **[AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)**
- **[Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)**
- **[Project Main README](../../README.md)**

## 🆘 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the main project documentation
3. Check existing GitHub issues
4. Create a new issue with detailed information
