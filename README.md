# KainosStudio Core Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-~%3E%201.10.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions)](https://github.com/features/actions)

A comprehensive Terraform-based infrastructure-as-code project for managing multi-cloud resources supporting the Kainos Core application platform. This project provides reusable modules and environment-specific configurations for serverless functions, storage, and related cloud services across AWS and Azure.

## 🏗️ Architecture Overview

The infrastructure supports a form-based application platform with the following key components:

- **Serverless Functions**: Main application logic for form processing and rendering (AWS Lambda / Azure Functions)
- **Upload Functions**: Specialized functions for handling KFD (Kainos Form Definition) file uploads
- **Cloud Storage**: Secure storage for form definitions and user uploads (S3 / Azure Storage)
- **Multi-Environment Support**: Separate configurations for dev, staging, and production environments
- **Multi-Cloud Support**: Infrastructure deployable to both AWS and Azure

## 📋 Prerequisites

Before you begin, ensure you have met the following requirements:

- **Terraform**: Ensure you have Terraform installed. You can install it using [tfenv](https://github.com/tfutils/tfenv) if the current version does not match the expected version in your environment.
- **Pre-commit**: Ensure you have pre-commit installed. If not, it will be installed during the `init` process.
- **Python**: Required for installing pre-commit.
- **Cloud CLI**: 
  - **AWS CLI**: Configured with appropriate credentials and permissions (for AWS deployments)
  - **Azure CLI**: Configured with appropriate credentials and permissions (for Azure deployments)
- **Node.js**: Required for serverless function development and testing

## 🚀 Getting Started

### Cloning the Repository

```bash
git clone <this-repo>
cd KainosStudio-CoreInfra
```

### Choose Your Cloud Provider

This project supports multiple cloud providers. Navigate to the provider-specific directory:

#### For AWS Deployment
```bash
cd aws
```

#### For Azure Deployment
```bash
cd azure
```

### Initial Setup

Once you've selected your provider directory, run:

```bash
make init dev
```

This command will:
- Initialize Terraform backend for the selected provider
- Install pre-commit hooks
- Download required providers and modules

## 🛠️ Makefile Commands

Each provider directory includes a Makefile with commands to manage Terraform configurations and pre-commit hooks.

### Environments

- `dev`: Development environment (default)
- `staging`: Staging environment  
- `pipeline`: Pipeline environment
- `prod`: Production environment

### Actions

- `init`: Initialize Terraform and pre-commit dependencies
- `plan`: Create a Terraform plan
- `apply`: Apply Terraform changes using the plan
- `destroy`: Destroy Terraform infrastructure
- `fmt`: Format Terraform files
- `validate`: Validate Terraform configuration
- `checkov`: Run Checkov security scan
- `check`: Run `fmt`, `validate`, and Checkov scan
- `pre-commit-install`: Install pre-commit hooks
- `pre-commit-run`: Run pre-commit hooks

### Usage Examples

```bash
# For AWS - Plan changes for development environment
cd aws
make plan dev

# For Azure - Apply changes to staging environment
cd azure
make apply staging

# Run security scan (from respective provider directory)
make checkov prod

# Format and validate all configurations
make check
```

## 📁 Project Structure

```
KainosStudio-CoreInfra/
├── aws/                     # AWS-specific infrastructure
│   ├── modules/
│   │   ├── lambda/          # AWS Lambda module
│   │   └── s3/              # AWS S3 module
│   ├── dev/
│   │   ├── resources.tf     # AWS Core Resources
│   │   └── lambdas/
│   │       ├── core/        # Core application Lambda
│   │       └── upload/      # Upload handling Lambda
│   ├── staging/
│   ├── prod/
│   ├── pipeline/
│   ├── Makefile             # AWS-specific commands
│   └── checkov.yaml         # AWS security scanning config
├── azure/                   # Azure-specific infrastructure
│   ├── modules/
│   │   ├── function-app/    # Azure Functions module
│   │   └── storage/         # Azure Storage module
│   ├── dev/
│   │   ├── resources.tf     # Azure Core Resources
│   │   └── functions/
│   │       ├── core/        # Core application Function
│   │       └── upload/      # Upload handling Function
│   ├── staging/
│   ├── prod/
│   ├── pipeline/
│   ├── Makefile             # Azure-specific commands
│   └── checkov.yaml         # Azure security scanning config
├── .github/                 # GitHub Actions workflows
├── .pre-commit-config.yaml  # Pre-commit configuration
└── README.md                # This file
```

## 🧩 Modules

### AWS Modules

#### Lambda Module

A versatile module for deploying AWS Lambda functions with comprehensive configuration options.

**Key Features:**
- Configurable runtime, memory, and timeout settings
- Environment variable management
- CloudWatch logging with encryption
- Version management and aliasing
- Automated source code packaging

**Basic Usage:**
```hcl
module "my_lambda" {
  source = "./modules/lambda"
  
  function_name             = "myFunction"
  description               = "My Lambda function"
  env                       = "dev"
  handler                   = "index.handler"
  runtime                   = "nodejs18.x"
  memory_size               = 256
  environment_variables     = {
    NODE_ENV = "development"
  }
  logs_retention_days       = 30
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.logs.arn
  lambda_source_dir         = "src/"
  publish                   = true
}
```

#### S3 Module

A comprehensive module for creating and managing S3 buckets with security best practices.

**Key Features:**
- Server-side encryption with KMS
- Versioning and lifecycle management
- Access logging configuration
- Public access blocking
- Automated file uploads
- Comprehensive tagging

**Basic Usage:**
```hcl
module "kfd_files_bucket" {
  source = "./modules/s3"
  
  bucket_name                = "my-bucket-name"
  enable_versioning          = true
  enable_encryption          = true
  enable_public_access_block = true
  kms_key_id                 = aws_kms_key.s3.arn
  
  tags = {
    Environment = "development"
    Project     = "kainoscore"
  }
}
```

### Azure Modules

#### Function App Module

A comprehensive module for deploying Azure Functions with enterprise-grade configuration.

**Key Features:**
- Configurable runtime and scaling settings
- Application settings management
- Application Insights integration
- Version management
- Automated deployment from source

#### Storage Module

A secure module for creating and managing Azure Storage accounts with best practices.

**Key Features:**
- Encryption at rest and in transit
- Access tier management
- Network access controls
- Comprehensive monitoring
- Automated lifecycle management

## 🚀 Application Components

### Core Application Function

The main application component that:
- Serves form definitions from cloud storage or local storage
- Handles user authentication and sessions
- Processes form submissions
- Manages file uploads

**Environment Variables (AWS):**
- `COOKIE_SECRET`: Session data encryption
- `SESSION_SECRET`: Authentication session encryption
- `BUCKET_NAME`: KFD files storage location
- `AUTH_CONFIG_FILE_NAME`: Authentication configuration file name (default: "auth")
- `BUCKET_NAME_FOR_FORM_FILES`: S3 bucket name for storing files uploaded by users
- `BUCKET_REGION_FOR_FORM_FILES`: AWS region where the file storage bucket is hosted
- `USE_LOCAL_SERVICES`: Enable local development mode (default: false)
- `LOG_LEVEL`: Application logging level (default: info)
- `PORT`: Application port (default: 3000)
- `CLOUD_PROVIDER`: must be 'aws'
- `FORM_SESSION_TABLE_NAME`: Table name for storing user's form data 
- `ALLOWED_ORIGIN`: Used for API endpoint CORS configuration

**Environment Variables (Azure):**
- `COOKIE_SECRET`: Session data encryption
- `SESSION_SECRET`: Authentication session encryption
- `AUTH_CONFIG_FILE_NAME`: Authentication configuration file name (default: "auth")
- `USE_LOCAL_SERVICES`: Enable local development mode (default: false)
- `LOG_LEVEL`: Application logging level (default: info)
- `PORT`: Application port (default: 3000)
- `CLOUD_PROVIDER`: must be 'azure'
- `AZURE_STORAGE_ACCOUNT`: Azure Storage Account name for KFD files
- `AZURE_STORAGE_CONTAINER`: Azure Storage Container name for KFD files
- `AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES`: Azure Storage Account name for storing files uploaded by users
- `AZURE_STORAGE_CONTAINER_FOR_FORM_FILES`: Azure Storage Container name for storing files uploaded by users
- `AZURE_COSMOS_ENDPOINT`: Azure Cosmos DB endpoint URL
- `AZURE_COSMOS_DATABASE`: Azure Cosmos DB database name
- `FORM_SESSION_TABLE_NAME`: Table name for storing user's form data
- `ALLOWED_ORIGIN`: Used for API endpoint CORS configuration

### Upload Function

Specialized function for handling KFD file uploads:
- Validates and processes form definition files
- Manages cloud storage upload operations
- Handles authentication for upload operations

### Environment Configuration

Create a `.env` file in the respective function directories:

**AWS Core Application (.env):**
```env
COOKIE_SECRET='your-cookie-secret'
SESSION_SECRET='your-session-secret'
CLOUD_PROVIDER='aws'
BUCKET_NAME='your-kfd-files-bucket'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='true'
LOG_LEVEL='debug'
BUCKET_NAME_FOR_FORM_FILES='your-form-files-bucket'
BUCKET_REGION_FOR_FORM_FILES='your-aws-region'
FORM_SESSION_TABLE_NAME='Core_FormSessions_dev'
```

**Azure Core Application (.env):**
```env
COOKIE_SECRET='your-cookie-secret'
SESSION_SECRET='your-session-secret'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='true'
LOG_LEVEL='debug'
CLOUD_PROVIDER='azure'
AZURE_STORAGE_ACCOUNT='your-storage-account'
AZURE_STORAGE_CONTAINER='kfd-files'
AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES='your-form-files-storage-account'
AZURE_STORAGE_CONTAINER_FOR_FORM_FILES='submitted-forms'
AZURE_COSMOS_ENDPOINT='https://your-cosmosdb.documents.azure.com:443/'
AZURE_COSMOS_DATABASE='your-database-name'
FORM_SESSION_TABLE_NAME='FormSessions'
```

## 🚀 Deployment

### GitHub Actions Pipeline

This project uses GitHub Actions for CI/CD workflows. The workflows are defined in the [`.github/workflows/`](.github/workflows) directory and handle:

- Terraform plan, apply, and destroy operations for both providers
- Running pre-commit hooks and formatting checks
- Security scanning with Checkov
- Testing serverless functions
- Provider-specific deployment workflows

### Deployment Differences

#### AWS Deployment
- **Local**: Uses `local.ts` entry point, can load forms from `services` folder
- **AWS**: Uses `lambda.ts` entry point, loads forms from S3 buckets

#### Azure Deployment
- **Local**: Uses `local.ts` entry point, can load forms from `services` folder
- **Azure**: Uses `function.ts` entry point, loads forms from Azure Storage

### Manual KFD Upload

#### AWS Production
1. Navigate to [AWS S3 Console](https://eu-west-2.console.aws.amazon.com/s3/)
2. Open the production KFD files bucket
3. Create or navigate to the appropriate folder
4. Upload your KFD file

#### Azure Production
1. Navigate to [Azure Portal](https://portal.azure.com/)
2. Open the production Storage Account
3. Navigate to the appropriate container
4. Upload your KFD file

## 🔒 Security Features

### AWS Security
- **Encryption**: All S3 buckets use KMS encryption
- **Access Control**: Public access blocked by default
- **Logging**: Comprehensive CloudWatch logging with retention policies
- **IAM**: Least-privilege access patterns

### Azure Security
- **Encryption**: Storage accounts use customer-managed keys
- **Access Control**: Network access restrictions and Azure AD integration
- **Logging**: Azure Monitor and Application Insights integration
- **RBAC**: Role-based access control patterns

### Common Security
- **Security Scanning**: Automated Checkov security analysis for both providers
- **Infrastructure as Code**: Version-controlled security configurations
- **Secrets Management**: Environment-specific secret handling

## 🏷️ Tagging Strategy

All resources are tagged with:
- `Environment`: dev/staging/prod
- `Owner`: Terraform
- `Project`: KainosStudio
- `Service`: Kainoscore
- `Provider`: aws/azure

## 📊 Monitoring and Logging

### AWS Monitoring
- **CloudWatch Logs**: Centralized logging for all Lambda functions
- **CloudWatch Metrics**: Custom metrics for application performance
- **CloudWatch Alarms**: Automated alerting for critical issues

### Azure Monitoring
- **Azure Monitor**: Centralized logging and monitoring
- **Application Insights**: Application performance monitoring
- **Azure Alerts**: Automated alerting for critical issues

### Common Features
- **Retention**: Configurable log retention periods
- **Performance Metrics**: Application and infrastructure monitoring
- **Cost Optimization**: Resource utilization tracking

### Code Quality

This project uses:
- **Pre-commit hooks**: Automated code formatting and validation
- **Terraform fmt**: Code formatting for both providers
- **Terraform validate**: Configuration validation
- **Checkov**: Security and compliance scanning for both AWS and Azure

### Provider-Specific Guidelines

#### AWS Contributions
- Follow AWS Well-Architected Framework principles
- Use AWS-native services where possible
- Ensure compatibility with existing Lambda functions

#### Azure Contributions
- Follow Azure Well-Architected Framework principles
- Use Azure-native services where possible
- Ensure compatibility with existing Function Apps

## 📚 Documentation

### Azure Deployment Documentation
- **[Azure Deployment Summary](./docs/AZURE_DEPLOYMENT_SUMMARY.md)**: Overview of current vs planned Azure architecture
- **[Azure CDN Deployment Architecture](./docs/AZURE_CDN_DEPLOYMENT_ARCHITECTURE.md)**: Detailed CDN routing and architecture documentation
- **[Testing Guide](./docs/TESTING.md)**: Comprehensive testing procedures for Azure infrastructure
- **[CDN Architecture Analysis](./docs/CDN_ARCHITECTURE_ANALYSIS.md)**: Original architecture analysis and recommendations

### General Documentation
- **[Security Best Practices](./docs/SECURITY_BEST_PRACTICES.md)**: Security guidelines for both AWS and Azure
- **[Makefile Usage](./docs/MAKEFILE_USAGE.md)**: Detailed guide for using project Makefiles
- **[Unified Domain Architecture](./docs/UNIFIED_DOMAIN_ARCHITECTURE.md)**: Cross-cloud domain architecture strategies

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- **AWS Resources:**
  - [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)
  - [AWS S3 User Guide](https://docs.aws.amazon.com/s3/latest/userguide/)
- **Azure Resources:**
  - [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)
  - [Azure Storage Documentation](https://docs.microsoft.com/en-us/azure/storage/)

---

## License

This project is licensed under the terms of the license file included in this repository. Please see the [LICENSE](LICENSE) file for more information.

## Contributing

We welcome contributions to Kainos Core Infra! Please read our [contributing guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

**Note**: This README is subject to changes as the project evolves. Please check back regularly for updates and new features.


**Last Updated**: August 2025