# Cloud Connectivity Security Guide

This guide covers security configurations for GitHub connectivity to AWS and Azure, including OIDC, GitHub runners, and IAM roles.

## 🔗 GitHub to Cloud Connectivity

### Overview

The project uses OpenID Connect (OIDC) for secure, keyless authentication from GitHub Actions to cloud providers, eliminating the need for long-lived credentials.

## 🟠 AWS Security Configuration

### OIDC Provider Setup

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **OIDC Provider** | `https://token.actions.githubusercontent.com` | GitHub Actions identity provider |
| **Audience** | `sts.amazonaws.com` | AWS STS service identifier |
| **Thumbprint** | `6938fd4d98bab03faadb97b34396831e3780aea1` | GitHub's certificate thumbprint |
| **Subject Claims** | `repo:org/repo:ref:refs/heads/main` | Repository and branch restrictions |

### IAM Roles and Policies

| Role | Trust Policy | Permissions | Environment |
|------|-------------|-------------|-------------|
| **GitHubActions-Dev-Role** | GitHub OIDC + dev branch | Lambda, S3, CloudWatch (dev resources only) | Development |
| **GitHubActions-Staging-Role** | GitHub OIDC + main branch | Enhanced permissions + deployment | Staging |
| **GitHubActions-Prod-Role** | GitHub OIDC + release tags | Full deployment + backup permissions | Production |

#### Development Role Trust Policy
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:org/KainosStudio-CoreInfra-Public:ref:refs/heads/*"
        }
      }
    }
  ]
}
```

#### Production Role Trust Policy
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:org/KainosStudio-CoreInfra-Public:ref:refs/tags/v*"
        }
      }
    }
  ]
}
```

### GitHub Runners Configuration

| Runner Type | Security Features | Use Case |
|-------------|------------------|----------|
| **GitHub-hosted** | Ephemeral, isolated environments | Standard deployments |
| **Self-hosted** | Private network access, custom security | Sensitive operations |

#### GitHub-hosted Runner Security
- Automatic cleanup after job completion
- No persistent storage
- Network isolation
- Regular security updates

#### Self-hosted Runner Security (if used)
- Private subnet deployment
- Security group restrictions
- Regular patching and updates
- Monitoring and logging

### AWS Security Best Practices

| Security Control | Implementation | Monitoring |
|------------------|----------------|------------|
| **Least Privilege** | Role-based permissions per environment | IAM Access Analyzer |
| **Network Security** | VPC endpoints, private subnets | VPC Flow Logs |
| **Encryption** | KMS customer-managed keys | CloudTrail KMS events |
| **Audit Logging** | CloudTrail, Config, GuardDuty | CloudWatch alarms |

## 🔵 Azure Security Configuration

### OIDC Provider Setup

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **App Registration** | GitHub Actions service principal | Azure AD identity |
| **Federated Credentials** | GitHub repository and branch conditions | OIDC trust relationship |
| **Audience** | `api://AzureADTokenExchange` | Azure AD token exchange |
| **Subject Claims** | `repo:org/repo:environment:prod` | Environment-specific access |

### Service Principals and RBAC

| Service Principal | Role Assignment | Scope | Environment |
|-------------------|----------------|-------|-------------|
| **github-actions-dev** | Contributor | Dev Resource Group | Development |
| **github-actions-staging** | Contributor | Staging Resource Group | Staging |
| **github-actions-prod** | Owner | Prod Resource Group | Production |

#### Federated Credential Configuration
```json
{
  "name": "github-actions-prod",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:org/KainosStudio-CoreInfra-Public:environment:prod",
  "audience": "api://AzureADTokenExchange"
}
```

### GitHub Runners Configuration

| Runner Type | Security Features | Use Case |
|-------------|------------------|----------|
| **GitHub-hosted** | Microsoft-managed, isolated | Standard deployments |
| **Self-hosted** | Azure-hosted, private network | Sensitive operations |

#### Azure-hosted Self-hosted Runners
- Azure Container Instances or VM Scale Sets
- Private virtual network integration
- Azure Security Center monitoring
- Managed identity authentication

### Azure Security Best Practices

| Security Control | Implementation | Monitoring |
|------------------|----------------|------------|
| **Identity Management** | Azure AD with conditional access | Azure AD logs |
| **Network Security** | Private endpoints, NSGs | Network Watcher |
| **Encryption** | Customer-managed keys in Key Vault | Key Vault audit logs |
| **Audit Logging** | Activity logs, Security Center | Azure Monitor |

## 🔐 Secrets Management

### GitHub Secrets Configuration

| Secret Type | AWS Implementation | Azure Implementation |
|-------------|-------------------|---------------------|
| **Cloud Credentials** | OIDC (no secrets needed) | OIDC (no secrets needed) |
| **Application Secrets** | AWS Secrets Manager | Azure Key Vault |
| **Terraform State** | S3 + DynamoDB | Azure Storage + State Lock |

### Environment-Specific Secrets

#### Development Environment
```yaml
# GitHub Repository Secrets
AWS_ROLE_ARN: arn:aws:iam::ACCOUNT:role/GitHubActions-Dev-Role
AZURE_CLIENT_ID: dev-client-id
AZURE_TENANT_ID: tenant-id
AZURE_SUBSCRIPTION_ID: dev-subscription-id
```

#### Production Environment
```yaml
# GitHub Environment Secrets (with protection rules)
AWS_ROLE_ARN: arn:aws:iam::ACCOUNT:role/GitHubActions-Prod-Role
AZURE_CLIENT_ID: prod-client-id
AZURE_TENANT_ID: tenant-id
AZURE_SUBSCRIPTION_ID: prod-subscription-id
```

## 🛡️ Security Monitoring

### AWS Security Monitoring

| Service | Purpose | Alerts |
|---------|---------|--------|
| **CloudTrail** | API call auditing | Unusual API activity |
| **GuardDuty** | Threat detection | Malicious activity |
| **Config** | Compliance monitoring | Configuration drift |
| **Security Hub** | Centralized security findings | Security violations |

### Azure Security Monitoring

| Service | Purpose | Alerts |
|---------|---------|--------|
| **Activity Log** | Resource activity auditing | Unauthorized changes |
| **Security Center** | Security posture management | Security recommendations |
| **Sentinel** | SIEM and threat hunting | Advanced threats |
| **Key Vault Logs** | Secret access auditing | Unauthorized access |

## 🚨 Incident Response

### Security Incident Types

| Incident Type | AWS Response | Azure Response |
|---------------|--------------|----------------|
| **Compromised Credentials** | Rotate IAM keys, review CloudTrail | Rotate secrets, review Activity Log |
| **Unauthorized Access** | Review IAM policies, enable MFA | Review RBAC, enable conditional access |
| **Data Breach** | S3 access analysis, GuardDuty alerts | Storage access review, Security Center |
| **Malicious Activity** | GuardDuty investigation | Sentinel investigation |

### Response Procedures

1. **Immediate Response**
   - Disable compromised accounts
   - Rotate affected credentials
   - Enable additional monitoring

2. **Investigation**
   - Review audit logs
   - Identify scope of impact
   - Document findings

3. **Remediation**
   - Implement security fixes
   - Update policies and procedures
   - Conduct post-incident review

## 🔍 Compliance and Auditing

### Compliance Frameworks

| Framework | AWS Services | Azure Services |
|-----------|-------------|----------------|
| **SOC 2** | CloudTrail, Config | Activity Log, Security Center |
| **ISO 27001** | Security Hub, GuardDuty | Security Center, Sentinel |
| **GDPR** | S3 encryption, access logs | Storage encryption, audit logs |

### Regular Security Reviews

| Review Type | Frequency | Scope |
|-------------|-----------|-------|
| **Access Review** | Quarterly | IAM roles, RBAC assignments |
| **Security Scan** | Monthly | Infrastructure, applications |
| **Compliance Audit** | Annually | Full security posture |
| **Penetration Test** | Annually | External security assessment |

## 📚 References

- **[AWS IAM OIDC Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)**
- **[Azure Workload Identity Federation](https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation)**
- **[GitHub Actions OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)**
- **[Terraform AWS Provider Authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)**
- **[Terraform Azure Provider Authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_oidc)**
