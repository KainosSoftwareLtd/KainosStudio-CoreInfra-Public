# Production Environment Setup Guide

This guide provides step-by-step instructions for setting up the Kainos Studio production environment.

## 🎯 Overview

The production environment is designed for:
- Live user traffic and operations
- Maximum security and compliance
- High availability and disaster recovery
- Comprehensive monitoring and alerting
- Automated backup and recovery

## 📋 Prerequisites

- Successful staging environment deployment
- All staging tests passed
- Security compliance validation completed
- Senior team approval obtained
- Production readiness checklist completed

## 🚨 Production Readiness Checklist

Before proceeding, ensure:
- [ ] All staging tests pass consistently
- [ ] Performance benchmarks met
- [ ] Security scan results reviewed and approved
- [ ] Disaster recovery plan documented and tested
- [ ] Monitoring and alerting configured
- [ ] Backup procedures validated
- [ ] Compliance requirements met
- [ ] Senior team sign-off obtained

## 🚀 Setup Instructions

### 1. Create Production Release

```bash
# Create and push production release tag
git tag -a v1.0.0 -m "Production release v1.0.0"
git push origin v1.0.0
```

### 2. Navigate to Provider Directory

#### For AWS Production
```bash
cd aws
```

#### For Azure Production
```bash
cd azure
```

### 3. Initialize Production Environment

```bash
make init prod
```

### 4. Configure Production Environment Variables

#### AWS Production (.env in aws/prod/lambdas/core/)
```env
COOKIE_SECRET='production-cookie-secret-highly-secure'
SESSION_SECRET='production-session-secret-highly-secure'
CLOUD_PROVIDER='aws'
BUCKET_NAME='kainos-core-kfd-files-prod'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='false'
LOG_LEVEL='warn'
BUCKET_NAME_FOR_FORM_FILES='kainos-core-form-files-prod'
BUCKET_REGION_FOR_FORM_FILES='eu-west-2'
FORM_SESSION_TABLE_NAME='Core_FormSessions_prod'
ALLOWED_ORIGIN='https://kainoscore.example.com'
```

#### Azure Production (.env in azure/prod/functions/core/)
```env
COOKIE_SECRET='production-cookie-secret-highly-secure'
SESSION_SECRET='production-session-secret-highly-secure'
AUTH_CONFIG_FILE_NAME='auth'
PORT=3000
USE_LOCAL_SERVICES='false'
LOG_LEVEL='warn'
CLOUD_PROVIDER='azure'
AZURE_STORAGE_ACCOUNT='kainoscorestoragepr'
AZURE_STORAGE_CONTAINER='kfd-files'
AZURE_STORAGE_ACCOUNT_FOR_FORM_FILES='kainosformfilesprod'
AZURE_STORAGE_CONTAINER_FOR_FORM_FILES='submitted-forms'
AZURE_COSMOS_ENDPOINT='https://kainos-core-cosmos-prod.documents.azure.com:443/'
AZURE_COSMOS_DATABASE='KainosCore'
FORM_SESSION_TABLE_NAME='FormSessions'
ALLOWED_ORIGIN='https://kainoscore.example.com'
```

### 5. Enhanced Security Validation

```bash
# Run comprehensive security scan
make checkov prod

# Additional security validations
# - Penetration testing results
# - Compliance audit results
# - Security architecture review
```

### 6. Plan Production Infrastructure

```bash
make plan prod
```

**Critical Review Points:**
- High availability configurations
- Disaster recovery settings
- Security group restrictions
- Backup and retention policies
- Monitoring and alerting setup
- Cost optimization settings

### 7. Senior Team Approval

Present the Terraform plan to senior team for approval:
- Infrastructure architecture review
- Security configuration validation
- Cost impact assessment
- Risk assessment and mitigation

### 8. Pre-deployment Backup

```bash
# Create backup of current production state (if updating)
terraform state pull > prod-backup-$(date +%Y%m%d-%H%M%S).json

# Document current configuration
terraform show > prod-current-config-$(date +%Y%m%d-%H%M%S).txt
```

### 9. Deploy Production Infrastructure

```bash
make apply prod
```

**Deployment Strategy:**
- Blue-green deployment where possible
- Gradual traffic shifting
- Real-time monitoring during deployment
- Immediate rollback capability

## 🏗️ Production Infrastructure Components

### AWS Production Resources

Refer to [AWS Terraform modules](../../aws/modules/) for detailed specifications.

**Production-Grade Features:**
- Multi-AZ Lambda deployment
- S3 Cross-Region Replication
- Enhanced CloudWatch monitoring with custom metrics
- AWS Config for compliance monitoring
- AWS CloudTrail for audit logging
- AWS Backup for automated backups
- AWS WAF for application protection

**Resource Specifications:**
- Lambda: 1GB memory, 30s timeout, reserved concurrency
- S3: Versioning enabled, MFA delete, lifecycle policies
- CloudWatch: 90-day log retention, custom dashboards
- KMS: Customer-managed keys with rotation

### Azure Production Resources

Refer to [Azure Terraform modules](../../azure/modules/) for detailed specifications.

**Production-Grade Features:**
- Premium Function App plans with auto-scaling
- Geo-redundant storage with read access
- Enhanced Application Insights with custom telemetry
- Azure Security Center integration
- Azure Backup for automated backups
- Azure Front Door for global load balancing

**Resource Specifications:**
- Function Apps: Premium plan, auto-scale enabled
- Storage: GRS with RA-GRS for critical data
- Application Insights: 90-day retention, custom metrics
- Key Vault: Premium tier with HSM backing

## 📊 Production Monitoring

### AWS Monitoring Setup

**CloudWatch Dashboards:**
```
Production Dashboard Components:
- Application Performance (response times, error rates)
- Infrastructure Health (CPU, memory, storage)
- Business Metrics (form submissions, user activity)
- Security Events (failed logins, suspicious activity)
```

**CloudWatch Alarms:**
- Lambda function errors > 1%
- Response time > 5 seconds
- Storage utilization > 80%
- Failed authentication attempts > 10/minute

### Azure Monitoring Setup

**Application Insights:**
```
Production Monitoring Components:
- Application Map with dependencies
- Live Metrics Stream
- Custom telemetry and KPIs
- User behavior analytics
```

**Azure Monitor Alerts:**
- Function execution failures
- High response times
- Storage capacity warnings
- Security event notifications

## 🔒 Production Security

### Security Hardening

1. **Network Security**
   ```
   - Private subnets for all compute resources
   - Network ACLs with deny-by-default
   - VPC Flow Logs enabled
   - DDoS protection enabled
   ```

2. **Data Protection**
   ```
   - Encryption at rest with customer-managed keys
   - Encryption in transit (TLS 1.3)
   - Key rotation every 90 days
   - Data classification and handling policies
   ```

3. **Access Control**
   ```
   - Least privilege access policies
   - Multi-factor authentication required
   - Regular access reviews (quarterly)
   - Privileged access management
   ```

### Compliance and Auditing

```bash
# Generate compliance report
terraform show -json | jq '.values.root_module.resources[] | select(.type | contains("aws_")) | {type, name, values}'

# Audit access logs
# Review CloudTrail/Activity Logs regularly
# Generate compliance reports monthly
```

## 🔄 Production Operations

### Deployment Workflow

1. **Pre-deployment Checks**
   - Staging validation complete
   - Security scans passed
   - Performance benchmarks met
   - Rollback plan prepared

2. **Deployment Execution**
   - Blue-green deployment
   - Health checks at each stage
   - Gradual traffic shifting
   - Real-time monitoring

3. **Post-deployment Validation**
   - Smoke tests execution
   - Performance validation
   - Security verification
   - User acceptance confirmation

### Maintenance Windows

**Scheduled Maintenance:**
- Monthly security updates
- Quarterly infrastructure reviews
- Semi-annual disaster recovery tests
- Annual security audits

**Emergency Maintenance:**
- Critical security patches
- Performance issues
- Service outages
- Data integrity issues

## 🚨 Incident Response

### Monitoring and Alerting

**Alert Severity Levels:**
- **Critical**: Service unavailable, data loss risk
- **High**: Performance degradation, security events
- **Medium**: Resource utilization warnings
- **Low**: Informational alerts

**Response Procedures:**
1. **Immediate Response** (< 15 minutes)
   - Acknowledge alert
   - Assess impact and severity
   - Initiate incident response

2. **Investigation** (< 1 hour)
   - Identify root cause
   - Implement temporary fixes
   - Document findings

3. **Resolution** (< 4 hours)
   - Implement permanent fix
   - Validate resolution
   - Update documentation

### Rollback Procedures

**Automated Rollback Triggers:**
- Error rate > 5%
- Response time > 10 seconds
- Health check failures
- Security breach detection

**Manual Rollback Process:**
```bash
# 1. Stop current deployment
terraform apply -var="deployment_enabled=false" prod

# 2. Revert to previous version
terraform apply -var="version=previous" prod

# 3. Validate rollback
npm run test:smoke:prod

# 4. Notify stakeholders
# Send incident notification with status
```

## 📈 Performance Optimization

### Monitoring KPIs

**Application Performance:**
- Response time < 2 seconds (95th percentile)
- Error rate < 0.1%
- Availability > 99.9%
- Throughput capacity planning

**Infrastructure Performance:**
- CPU utilization < 70%
- Memory utilization < 80%
- Storage utilization < 75%
- Network latency < 100ms

### Optimization Strategies

1. **Auto-scaling Configuration**
   - Predictive scaling based on historical data
   - Target tracking scaling policies
   - Scheduled scaling for known patterns

2. **Caching Strategies**
   - CDN for static content
   - Application-level caching
   - Database query optimization

3. **Resource Right-sizing**
   - Regular performance reviews
   - Cost optimization analysis
   - Capacity planning updates

## 📚 References

- **[Staging Setup Guide](./STAGING_SETUP.md)** - Previous environment setup
- **[CI/CD Guide](../CICD_GUIDE.md)** - Automated deployment workflows
- **[Security Guides](../security/)** - Comprehensive security documentation
- **[Monitoring Guide](../MONITORING_ALERTING.md)** - Detailed monitoring setup
- **[Networking Guide](../NETWORKING_GUIDE.md)** - Network architecture details
- **[Terraform AWS Modules](../../aws/modules/)** - Infrastructure blueprints
- **[Terraform Azure Modules](../../azure/modules/)** - Infrastructure blueprints

## 🆘 Emergency Contacts

**Escalation Matrix:**
1. **Level 1**: Development Team
2. **Level 2**: Senior Engineering Team
3. **Level 3**: Engineering Management
4. **Level 4**: Executive Team

**Contact Methods:**
- Primary: Work example/PagerDuty system
- Secondary: Teams or Slack (TBC) emergency channels
- Tertiary: Direct phone contacts

**External Contacts:**
- Cloud provider support (AWS/Azure)
- Security incident response team
- Legal and compliance team
- Public relations (for major incidents)
