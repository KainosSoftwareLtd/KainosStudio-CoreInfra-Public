# CI/CD Guide - GitHub Actions Workflows

This guide documents the CI/CD workflows and GitHub Actions for the Kainos Studio infrastructure project.

## 🔄 Workflow Overview

The project uses GitHub Actions for automated CI/CD across multiple environments and cloud providers.

## 📁 Workflow Structure - Example Files

```
.github/workflows/
├── aws-dev.yml          # AWS development environment
├── aws-staging.yml      # AWS staging environment  
├── aws-prod.yml         # AWS production environment
├── azure-dev.yml        # Azure development environment
├── azure-staging.yml    # Azure staging environment
├── azure-prod.yml       # Azure production environment
├── pre-commit.yml       # Code quality checks
└── security-scan.yml    # Security scanning
```

## 📋 Actual Workflow Files

### Non-Prod-Infra (Dev ~ Staging)

| Workflow File | Summary | Active |
|---------------|---------|--------|
| `pull-request.yaml` | Validates PR changes across dev/staging environments with Terraform plan and Checkov security scanning | ✅ |
| `nonprod-deployment.yaml` | Manual deployment workflow for non-prod infrastructure with apply option | ✅ |
| `nonprod-deploy-specific-env.yaml` | Targeted deployment to specific non-prod environments (pipeline/dev/staging) | ✅ |
| `nonprod-deploy-roles.yaml` | Deploys IAM roles and permissions for non-prod environments | ✅ |

### Prod-Infra (Prod)

| Workflow File | Summary | Active |
|---------------|---------|--------|
| `prod-deployment.yaml` | Manual deployment workflow for production infrastructure with apply option | ✅ |
| `prod-deploy-specific-env.yaml` | Targeted deployment to specific production environments | ✅ |
| `prod-deploy-roles.yaml` | Deploys IAM roles and permissions for production environments | ✅ |

## 🚀 Workflow Triggers

### Development Workflows
- **Trigger**: Push to feature branches
- **Actions**: Plan, validate, security scan
- **Approval**: None required

### Staging Workflows  
- **Trigger**: PR merge to main branch
- **Actions**: Plan, security scan, deploy, test
- **Approval**: Manual approval required

### Production Workflows
- **Trigger**: Release tag creation
- **Actions**: Enhanced security, plan, deploy, validate
- **Approval**: Senior team approval required

## 🔧 Workflow Components

### 1. Pre-commit Workflow
```yaml
name: Pre-commit Checks
on: [push, pull_request]
jobs:
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
      - uses: pre-commit/action@v3.0.0
```

### 2. Security Scan Workflow
```yaml
name: Security Scan
on: [push, pull_request]
jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform
```

### 3. Terraform Workflow Template
```yaml
name: Terraform Deploy
on:
  workflow_dispatch:
    inputs:
      environment:
        required: true
        type: choice
        options: [dev, staging, prod]

jobs:
  terraform:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - name: Terraform Init
        run: terraform init
      - name: Terraform Plan
        run: terraform plan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

## 🔐 Secrets Management

### Required Secrets

#### AWS Workflows
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
TF_VAR_cookie_secret
TF_VAR_session_secret
```

#### Azure Workflows
```
AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID
TF_VAR_cookie_secret
TF_VAR_session_secret
```

### Environment-Specific Secrets
- **Development**: Basic secrets for testing
- **Staging**: Enhanced secrets with rotation
- **Production**: Highly secure secrets with HSM backing

## 🎯 Environment-Specific Workflows

### Development Environment

**Trigger Conditions:**
- Push to feature branches
- Pull request creation

**Workflow Steps:**
1. Checkout code
2. Setup Terraform
3. Run pre-commit checks
4. Terraform validate
5. Terraform plan
6. Security scan (Checkov)
7. Comment plan on PR

**Approval**: None required

### Staging Environment

**Trigger Conditions:**
- PR merge to main branch
- Manual workflow dispatch

**Workflow Steps:**
1. Checkout code
2. Setup Terraform
3. Enhanced security validation
4. Terraform plan
5. Manual approval gate
6. Terraform apply
7. Run integration tests
8. Performance validation
9. Notify stakeholders

**Approval**: Development team lead

### Production Environment

**Trigger Conditions:**
- Release tag creation (v*.*.*)
- Manual workflow dispatch (restricted)

**Workflow Steps:**
1. Checkout code
2. Setup Terraform
3. Comprehensive security scan
4. Compliance validation
5. Terraform plan
6. Senior team approval gate
7. Pre-deployment backup
8. Standard deployment
9. Health checks
10. Smoke tests
11. Traffic switching
12. Post-deployment validation
13. Rollback capability

**Approval**: Senior engineering team + management

## 🔍 Workflow Actions Detail

### Terraform Actions

```yaml
- name: Setup Terraform
  uses: hashicorp/setup-terraform@v3
  with:
    terraform_version: ~1.10.0

- name: Terraform Format Check
  run: terraform fmt -check -recursive

- name: Terraform Init
  run: terraform init

- name: Terraform Validate
  run: terraform validate

- name: Terraform Plan
  run: terraform plan -out=tfplan

- name: Terraform Apply
  run: terraform apply tfplan
```

### Security Actions

```yaml
- name: Run Checkov
  uses: bridgecrewio/checkov-action@master
  with:
    directory: .
    framework: terraform
    output_format: sarif
    output_file_path: checkov.sarif

- name: Upload Checkov Results
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: checkov.sarif
```

### Testing Actions

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '18'

- name: Install Dependencies
  run: npm ci

- name: Run Unit Tests
  run: npm test

- name: Run Integration Tests
  run: npm run test:integration

- name: Run Smoke Tests
  run: npm run test:smoke
```

## 📊 Monitoring and Notifications

### Workflow Monitoring

**Success Notifications:**
- Slack/Teams channel updates
- Email notifications to stakeholders
- GitHub status checks

**Failure Notifications:**
- Immediate alerts to development team
- Detailed error logs and artifacts
- Automatic rollback triggers

### Workflow Metrics

**Tracked Metrics:**
- Deployment frequency
- Lead time for changes
- Mean time to recovery
- Change failure rate

## 🚨 Rollback Procedures

### Automated Rollback Triggers

```yaml
- name: Health Check
  run: |
    if ! curl -f ${{ env.HEALTH_CHECK_URL }}; then
      echo "Health check failed, triggering rollback"
      terraform apply -var="rollback=true" -auto-approve
    fi
```

### Manual Rollback Process

1. **Identify Issue**
   - Monitor workflow logs
   - Check application health
   - Assess impact scope

2. **Execute Rollback**
   ```bash
   # Via GitHub Actions
   gh workflow run rollback.yml -f environment=prod -f version=previous
   
   # Via CLI
   terraform apply -var="rollback=true" -auto-approve
   ```

3. **Validate Rollback**
   - Run smoke tests
   - Verify functionality
   - Update stakeholders

## 🔧 Workflow Customization

### Environment Variables

```yaml
env:
  TF_VAR_environment: ${{ inputs.environment }}
  TF_VAR_region: eu-west-2
  TF_VAR_project_name: kainos-studio
  CHECKOV_SKIP_CHECK: CKV_AWS_20,CKV_AZURE_35
```

### Conditional Steps

```yaml
- name: Production Only Step
  if: github.ref == 'refs/tags/v*'
  run: echo "Running production-specific actions"

- name: AWS Only Step
  if: contains(github.workflow, 'aws')
  run: echo "Running AWS-specific actions"
```

## 📚 Best Practices

### Workflow Security
- Use OIDC for cloud authentication
- Minimize secret exposure
- Implement least privilege access
- Regular secret rotation

### Performance Optimization
- Cache Terraform providers
- Parallel job execution
- Artifact reuse between jobs
- Conditional workflow execution

### Reliability
- Comprehensive error handling
- Retry mechanisms for transient failures
- Detailed logging and monitoring
- Regular workflow testing

## 🛠️ Troubleshooting

### Common Issues

1. **Authentication Failures**
   ```yaml
   - name: Debug Auth
     run: |
       aws sts get-caller-identity
       az account show
   ```

2. **Terraform State Locks**
   ```yaml
   - name: Force Unlock
     run: terraform force-unlock ${{ env.LOCK_ID }}
   ```

3. **Resource Conflicts**
   ```yaml
   - name: Import Existing Resources
     run: terraform import aws_s3_bucket.example bucket-name
   ```

### Debugging Steps

1. **Check Workflow Logs**
   - Review step-by-step execution
   - Identify failure points
   - Check environment variables

2. **Validate Terraform**
   ```bash
   terraform validate
   terraform plan -detailed-exitcode
   ```

3. **Test Locally**
   
   As per the [main README](../README.md), use the Makefile commands to test against specific environments:
   
   ```bash
   # For AWS - navigate to aws directory
   cd aws
   make plan dev     # Plan changes for development
   make plan staging # Plan changes for staging
   make plan prod    # Plan changes for production
   
   # For Azure - navigate to azure directory  
   cd azure
   make plan dev     # Plan changes for development
   make plan staging # Plan changes for staging
   make plan prod    # Plan changes for production
   
   # Run validation and security checks
   make check        # Format, validate, and security scan
   make checkov dev  # Security scan for specific environment
   ```

## 📋 Workflow Maintenance

### Regular Tasks
- Update action versions monthly
- Review and rotate secrets quarterly
- Performance optimization reviews
- Security audit of workflows

### Monitoring
- Workflow success/failure rates
- Execution time trends
- Resource utilization
- Cost optimization opportunities

## 📚 References

- **[GitHub Actions Documentation](https://docs.github.com/en/actions)**
- **[Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)**
- **[Checkov GitHub Action](https://github.com/bridgecrewio/checkov-action)**
- **[Setup Guides](./setup/)** - Environment-specific configurations
- **[Security Guides](./security/)** - Security best practices
- **[Main README](../README.md)** - Project overview and Makefile usage
