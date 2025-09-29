# Secrets, Auditing, and Logging Security Guide

This guide covers comprehensive security practices for secrets management, auditing, and logging across AWS and Azure environments.

## 🔐 Secrets Management

### Secrets Hierarchy

| Secret Type | Sensitivity | Storage Location | Rotation Frequency |
|-------------|-------------|------------------|-------------------|
| **Application Secrets** | High | Cloud secret stores | 90 days |
| **Database Credentials** | Critical | Cloud secret stores | 30 days |
| **API Keys** | Medium | Cloud secret stores | 180 days |
| **Encryption Keys** | Critical | Hardware Security Modules | 365 days |

## 🟠 AWS Secrets Management

### AWS Secrets Manager

| Component | Configuration | Security Features |
|-----------|---------------|------------------|
| **Secret Storage** | AWS Secrets Manager | Encryption at rest with KMS |
| **Access Control** | IAM policies | Least privilege access |
| **Rotation** | Automatic rotation | Lambda-based rotation |
| **Auditing** | CloudTrail integration | All access logged |

#### Secret Configuration Example
```json
{
  "SecretName": "kainos-core/prod/database",
  "Description": "Production database credentials",
  "KmsKeyId": "arn:aws:kms:region:account:key/key-id",
  "ReplicationRegions": [
    {
      "Region": "eu-west-1",
      "KmsKeyId": "arn:aws:kms:eu-west-1:account:key/key-id"
    }
  ],
  "SecretString": "{\"username\":\"admin\",\"password\":\"secure-password\"}"
}
```

### AWS Systems Manager Parameter Store

| Parameter Type | Use Case | Encryption | Access Pattern |
|----------------|----------|------------|----------------|
| **String** | Configuration values | Optional KMS | Application config |
| **StringList** | Multiple values | Optional KMS | Feature flags |
| **SecureString** | Sensitive data | Mandatory KMS | Credentials |

#### Parameter Store Security
```json
{
  "Name": "/kainos-core/prod/cookie-secret",
  "Type": "SecureString",
  "Value": "encrypted-secret-value",
  "KeyId": "alias/kainos-core-secrets",
  "Tier": "Advanced",
  "Policies": [
    {
      "Type": "Expiration",
      "Value": "2024-12-31T23:59:59Z"
    }
  ]
}
```

### AWS Key Management Service (KMS)

| Key Type | Purpose | Rotation | Access Control |
|----------|---------|----------|----------------|
| **Customer Managed** | Application encryption | Annual | IAM policies |
| **AWS Managed** | Service encryption | Automatic | Service-controlled |
| **CloudHSM** | High security requirements | Manual | Dedicated HSM |

## 🔵 Azure Secrets Management

### Azure Key Vault

| Component | Configuration | Security Features |
|-----------|---------------|------------------|
| **Secret Storage** | Azure Key Vault | Hardware security modules |
| **Access Control** | RBAC + Access policies | Fine-grained permissions |
| **Rotation** | Event-driven rotation | Logic Apps/Functions |
| **Auditing** | Diagnostic logs | All operations logged |

#### Key Vault Configuration
```json
{
  "name": "kainos-core-kv-prod",
  "location": "West Europe",
  "properties": {
    "sku": {
      "family": "A",
      "name": "premium"
    },
    "tenantId": "tenant-id",
    "enabledForDeployment": false,
    "enabledForTemplateDeployment": false,
    "enabledForDiskEncryption": false,
    "enableSoftDelete": true,
    "softDeleteRetentionInDays": 90,
    "enablePurgeProtection": true
  }
}
```

### Azure Managed Identity

| Identity Type | Use Case | Scope | Benefits |
|---------------|----------|-------|----------|
| **System Assigned** | Single resource | Resource-specific | Automatic lifecycle |
| **User Assigned** | Multiple resources | Cross-resource | Centralized management |

## 📊 Auditing and Compliance

### AWS Auditing Services

| Service | Purpose | Log Retention | Integration |
|---------|---------|---------------|-------------|
| **CloudTrail** | API call logging | 90 days (configurable) | CloudWatch, S3 |
| **Config** | Configuration changes | 7 years | CloudWatch, SNS |
| **GuardDuty** | Threat detection | 90 days | Security Hub |
| **Security Hub** | Security findings | 90 days | CloudWatch, SNS |

#### CloudTrail Configuration
```json
{
  "TrailName": "kainos-core-audit-trail",
  "S3BucketName": "kainos-core-audit-logs",
  "IncludeGlobalServiceEvents": true,
  "IsMultiRegionTrail": true,
  "EnableLogFileValidation": true,
  "EventSelectors": [
    {
      "ReadWriteType": "All",
      "IncludeManagementEvents": true,
      "DataResources": [
        {
          "Type": "AWS::S3::Object",
          "Values": ["arn:aws:s3:::kainos-core-*/*"]
        }
      ]
    }
  ]
}
```

### Azure Auditing Services

| Service | Purpose | Log Retention | Integration |
|---------|---------|---------------|-------------|
| **Activity Log** | Resource operations | 90 days | Log Analytics |
| **Diagnostic Logs** | Resource-specific logs | Configurable | Storage, Event Hub |
| **Security Center** | Security recommendations | 6 months | Log Analytics |
| **Sentinel** | SIEM and threat hunting | 2 years | Log Analytics |

#### Diagnostic Settings Configuration
```json
{
  "name": "kainos-core-diagnostics",
  "properties": {
    "workspaceId": "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/workspace",
    "logs": [
      {
        "category": "AuditEvent",
        "enabled": true,
        "retentionPolicy": {
          "enabled": true,
          "days": 365
        }
      }
    ],
    "metrics": [
      {
        "category": "AllMetrics",
        "enabled": true,
        "retentionPolicy": {
          "enabled": true,
          "days": 90
        }
      }
    ]
  }
}
```

## 📝 Logging Security

### Log Categories

| Log Category | AWS Service | Azure Service | Retention | Purpose |
|--------------|-------------|---------------|-----------|---------|
| **Authentication** | CloudTrail | Activity Log | 1 year | Access tracking |
| **Authorization** | CloudTrail | Activity Log | 1 year | Permission changes |
| **Data Access** | S3 Access Logs | Storage Analytics | 90 days | Data access patterns |
| **Security Events** | GuardDuty | Security Center | 90 days | Threat detection |
| **Application Logs** | CloudWatch | Log Analytics | 30 days | Application monitoring |

### Log Security Controls

| Control | AWS Implementation | Azure Implementation |
|---------|-------------------|---------------------|
| **Encryption** | CloudWatch Logs KMS | Log Analytics encryption |
| **Access Control** | IAM policies | RBAC permissions |
| **Integrity** | Log file validation | Immutable storage |
| **Retention** | Lifecycle policies | Retention policies |

### Critical Security Events

| Event Type | AWS Detection | Azure Detection | Response |
|------------|---------------|-----------------|----------|
| **Failed Logins** | CloudTrail analysis | Sign-in logs | Account lockout |
| **Privilege Escalation** | Config rules | Activity log alerts | Immediate review |
| **Data Exfiltration** | GuardDuty findings | Sentinel analytics | Incident response |
| **Unusual Access** | CloudWatch alarms | Log Analytics queries | Investigation |

## 🚨 Security Monitoring and Alerting

### AWS Security Monitoring

| Metric | Threshold | Alert Method | Response Time |
|--------|-----------|--------------|---------------|
| **Failed API Calls** | >10 in 5 minutes | SNS → Slack | 5 minutes |
| **Root Account Usage** | Any usage | SNS → Email | Immediate |
| **Unusual Data Transfer** | >1GB in 1 hour | CloudWatch → Lambda | 15 minutes |
| **Security Group Changes** | Any change | Config → SNS | 10 minutes |

#### CloudWatch Alarm Example
```json
{
  "AlarmName": "HighFailedAPICallsAlarm",
  "ComparisonOperator": "GreaterThanThreshold",
  "EvaluationPeriods": 1,
  "MetricName": "ErrorCount",
  "Namespace": "AWS/ApiGateway",
  "Period": 300,
  "Statistic": "Sum",
  "Threshold": 10,
  "ActionsEnabled": true,
  "AlarmActions": [
    "arn:aws:sns:region:account:security-alerts"
  ]
}
```

### Azure Security Monitoring

| Metric | Threshold | Alert Method | Response Time |
|--------|-----------|--------------|---------------|
| **Failed Sign-ins** | >5 in 10 minutes | Action Group → Teams | 5 minutes |
| **Admin Role Changes** | Any change | Activity log alert | Immediate |
| **Key Vault Access** | Unusual patterns | Log Analytics query | 15 minutes |
| **Resource Deletions** | Critical resources | Activity log alert | 10 minutes |

#### Azure Monitor Alert Rule
```json
{
  "name": "HighFailedSignInsAlert",
  "properties": {
    "description": "Alert when failed sign-ins exceed threshold",
    "severity": 2,
    "enabled": true,
    "scopes": ["/subscriptions/subscription-id"],
    "evaluationFrequency": "PT5M",
    "windowSize": "PT10M",
    "criteria": {
      "allOf": [
        {
          "query": "SigninLogs | where ResultType != 0 | summarize count() by bin(TimeGenerated, 5m)",
          "timeAggregation": "Count",
          "operator": "GreaterThan",
          "threshold": 5
        }
      ]
    },
    "actions": [
      {
        "actionGroupId": "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Insights/actionGroups/security-alerts"
      }
    ]
  }
}
```

## 🔍 Compliance and Reporting

### Compliance Frameworks

| Framework | AWS Services | Azure Services | Reporting Frequency |
|-----------|-------------|----------------|-------------------|
| **SOC 2 Type II** | Config, CloudTrail | Security Center, Activity Log | Quarterly |
| **ISO 27001** | Security Hub | Compliance Manager | Annually |
| **GDPR** | Data encryption, access logs | Data protection, audit logs | Ongoing |
| **PCI DSS** | GuardDuty, Config | Security Center | Quarterly |

### Automated Compliance Reporting

#### AWS Config Rules
```json
{
  "ConfigRuleName": "s3-bucket-ssl-requests-only",
  "Description": "Checks whether S3 buckets have policies that require requests to use SSL",
  "Source": {
    "Owner": "AWS",
    "SourceIdentifier": "S3_BUCKET_SSL_REQUESTS_ONLY"
  },
  "Scope": {
    "ComplianceResourceTypes": ["AWS::S3::Bucket"]
  }
}
```

#### Azure Policy Definition
```json
{
  "properties": {
    "displayName": "Require SSL for storage accounts",
    "description": "This policy ensures that storage accounts require SSL",
    "policyType": "Custom",
    "mode": "All",
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Storage/storageAccounts"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
            "notEquals": true
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
  }
}
```

## 🛡️ Incident Response for Security Events

### Security Incident Classification

| Severity | Description | Response Time | Escalation |
|----------|-------------|---------------|------------|
| **Critical** | Data breach, system compromise | 15 minutes | Immediate |
| **High** | Unauthorized access, privilege escalation | 1 hour | Within 2 hours |
| **Medium** | Policy violations, suspicious activity | 4 hours | Next business day |
| **Low** | Configuration drift, minor violations | 24 hours | Weekly review |

### Response Procedures

1. **Detection and Analysis**
   - Automated alert triggers
   - Log analysis and correlation
   - Impact assessment

2. **Containment and Eradication**
   - Isolate affected systems
   - Remove malicious artifacts
   - Patch vulnerabilities

3. **Recovery and Lessons Learned**
   - Restore normal operations
   - Monitor for recurrence
   - Update security controls

## 📚 References

- **[AWS Secrets Manager Best Practices](https://docs.aws.amazon.com/secretsmanager/latest/userguide/best-practices.html)**
- **[Azure Key Vault Security](https://docs.microsoft.com/en-us/azure/key-vault/general/security-features)**
- **[AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/)**
- **[Azure Monitor Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/)**
- **[NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)**
