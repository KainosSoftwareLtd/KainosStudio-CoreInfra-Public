# Staging Environment Setup Guide

This guide provides step-by-step instructions for setting up the Kainos Studio staging environment.

## 🎯 Overview

The staging environment is designed for:
- Integration testing and validation
- User Acceptance Testing (UAT)
- Performance testing
- Pre-production validation
- Stakeholder demonstrations

## 📋 Prerequisites

- Completed development environment setup
- All development tests passing
- Security scans completed successfully
- Stakeholder approval for staging deployment

## 🚀 Setup Instructions

### 1. Prepare for Staging Deployment

Ensure your changes are merged to the main branch:
```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull origin main

# Verify clean state
git status
```

### 2. Navigate to Provider Directory

#### For AWS Staging
```bash
cd aws
```

#### For Azure Staging
```bash
cd azure
```

### 3. Initialize Staging Environment

```bash
make init staging
```

### 4. Configure Staging Environment Variables

#### AWS Staging (.env in aws/staging/lambdas/core/)
```env
COOKIE_SECRET='staging-cookie-secret-secure-value'
SESSION_SECRET='staging-session-secret-secure-value'
CLOUD_PROVIDER='aws'
BUCKET_NAME='kainos-core-kfd-files-staging'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='false'
LOG_LEVEL='info'
BUCKET_NAME_FOR_FORM_FILES='kainos-core-form-files-staging'
BUCKET_REGION_FOR_FORM_FILES='eu-west-2'
FORM_SESSION_TABLE_NAME='Core_FormSessions_staging'
ALLOWED_ORIGIN='https://staging.kainoscore.example.com'
```

#### Azure Staging (.env in azure/staging/functions/core/)
```env
COOKIE_SECRET='staging-cookie-secret-secure-value'
SESSION_SECRET='staging-session-secret-secure-value'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='false'
LOG_LEVEL='info'
CLOUD_PROVIDER='azure'
AZURE_STORAGE_ACCOUNT='kainoscorestoragestagin'
AZURE_STORAGE_CONTAINER='kfd-files'
AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES='kainosformfilesstaging'
AZURE_STORAGE_CONTAINER_FOR_FORM_FILES='submitted-forms'
AZURE_COSMOS_ENDPOINT='https://kainos-core-cosmos-staging.documents.azure.com:443/'
AZURE_COSMOS_DATABASE='KainosCore'
FORM_SESSION_TABLE_NAME='FormSessions'
ALLOWED_ORIGIN='https://staging.kainoscore.example.com'
```

### 5. Run Security Validation

```bash
make checkov staging
```

Ensure all security checks pass before proceeding.

### 6. Plan Staging Infrastructure

```bash
make plan staging
```

Review the plan carefully:
- Verify resource naming includes "staging"
- Check security configurations
- Validate network settings
- Confirm monitoring setup

### 7. Apply Staging Infrastructure

```bash
make apply staging
```

**Note**: This may require manual approval depending on your CI/CD configuration.

## 🏗️ Infrastructure Components

### AWS Staging Resources

Refer to [AWS Terraform modules](../../aws/modules/) for detailed specifications.

**Enhanced Features vs Development:**
- Increased Lambda memory and timeout settings
- Enhanced CloudWatch monitoring with alarms
- Cross-AZ redundancy where applicable
- Enhanced security groups and NACLs
- Backup and disaster recovery configurations

### Azure Staging Resources

Refer to [Azure Terraform modules](../../azure/modules/) for detailed specifications.

**Enhanced Features vs Development:**
- Premium Function App plans for better performance
- Enhanced Application Insights monitoring
- Geo-redundant storage options
- Enhanced network security groups
- Backup and disaster recovery configurations

## 🧪 Testing Procedures

### 1. Smoke Tests

```bash
# Run basic connectivity tests
curl -f https://staging.kainoscore.example.com/health

# Test core functionality
npm run test:smoke:staging
```

### 2. Integration Tests

```bash
# Run full integration test suite
npm run test:integration:staging

# Test file upload functionality
npm run test:upload:staging
```

### 3. Performance Tests

```bash
# Run load tests
npm run test:load:staging

# Monitor performance metrics
# Check CloudWatch/Application Insights dashboards
```

### 4. User Acceptance Testing

1. **Deploy Test Data**
   - Upload sample KFD files
   - Configure test user accounts
   - Set up test scenarios

2. **UAT Checklist**
   - [ ] Form rendering functionality
   - [ ] File upload and processing
   - [ ] User authentication flows
   - [ ] Data persistence and retrieval
   - [ ] Error handling and recovery

3. **Stakeholder Sign-off**
   - Provide access to staging environment
   - Collect feedback and issues
   - Document any required changes

## 📊 Monitoring and Alerting

### AWS Monitoring Setup

**CloudWatch Dashboards:**
- Application performance metrics
- Infrastructure health metrics
- Error rates and response times
- Resource utilization

**CloudWatch Alarms:**
- Lambda function errors
- High response times
- Storage capacity warnings
- Security event notifications

### Azure Monitoring Setup

**Application Insights:**
- Application performance monitoring
- User behavior analytics
- Dependency tracking
- Custom telemetry

**Azure Monitor:**
- Infrastructure metrics
- Log analytics
- Alert rules
- Action groups for notifications

## 🔒 Security Considerations

### Enhanced Security Features

1. **Network Security**
   - Private subnets for sensitive resources
   - Network ACLs and security groups
   - VPC/VNet peering restrictions

2. **Data Protection**
   - Encryption at rest and in transit
   - Key rotation policies
   - Access logging and auditing

3. **Identity and Access**
   - Least privilege access policies
   - Multi-factor authentication requirements
   - Regular access reviews

### Security Validation

```bash
# Run comprehensive security scan
make checkov staging

# Validate network configurations
# Review IAM/RBAC policies
# Check encryption settings
```

## 🔄 Staging Workflow

### Automated Deployment (via GitHub Actions)

1. **Trigger**: PR merged to main branch
2. **Security Scan**: Automated Checkov validation
3. **Plan**: Terraform plan generation
4. **Approval**: Manual approval required
5. **Deploy**: Terraform apply execution
6. **Test**: Automated test suite execution
7. **Notify**: Stakeholder notification

### Manual Deployment

```bash
# 1. Validate configuration
make check

# 2. Plan changes
make plan staging

# 3. Apply changes (with approval)
make apply staging

# 4. Run tests
npm run test:staging

# 5. Notify stakeholders
# Send notification with staging URL and test results
```

## 🚨 Rollback Procedures

### Automated Rollback

If automated tests fail:
```bash
# Rollback to previous version
terraform apply -var="rollback=true" staging

# Or destroy and recreate from last known good state
make destroy staging
git checkout <last-good-commit>
make apply staging
```

### Manual Rollback

1. **Identify Issue**
   - Check monitoring dashboards
   - Review error logs
   - Assess impact scope

2. **Execute Rollback**
   ```bash
   # Revert to previous Terraform state
   terraform state pull > current-state.backup
   terraform apply -var="version=previous" staging
   ```

3. **Validate Rollback**
   - Run smoke tests
   - Verify functionality
   - Notify stakeholders

## 📚 References

- **[Development Setup Guide](./DEV_SETUP.md)** - Previous environment setup
- **[Production Setup Guide](./PROD_SETUP.md)** - Next environment setup
- **[CI/CD Guide](../CICD_GUIDE.md)** - Automated deployment workflows
- **[Monitoring Guide](../MONITORING_ALERTING.md)** - Detailed monitoring setup
- **[Terraform AWS Modules](../../aws/modules/)** - Infrastructure blueprints
- **[Terraform Azure Modules](../../azure/modules/)** - Infrastructure blueprints

## 🆘 Support and Troubleshooting

### Common Issues

1. **Deployment Failures**
   - Check Terraform state locks
   - Verify cloud provider quotas
   - Review IAM/RBAC permissions

2. **Performance Issues**
   - Monitor resource utilization
   - Check network connectivity
   - Review function timeout settings

3. **Test Failures**
   - Check environment variables
   - Verify test data setup
   - Review application logs

### Getting Help

1. Check monitoring dashboards first
2. Review application and infrastructure logs
3. Consult the troubleshooting sections in module documentation
4. Create detailed issue reports with logs and error messages
