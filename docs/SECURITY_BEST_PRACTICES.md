To get your Azure AD object ID (needed for role assignments), run:

```sh
az ad signed-in-user show --query id --output tsv
```

Copy the output and use it as <your-object-id> in role assignment commands.
# Security Best Practices

## Critical Security Guidelines

### 🚨 Never Commit These to Git:
- **Passwords, API keys, tokens**
- **SAS tokens or connection strings**
- **SSL certificate private keys**
- **ARM_CLIENT_SECRET values**
- **.env files with real values**
- **Personal email addresses in configs**

## Secure Secret Management

### 1. Environment Variables (Recommended)
```bash
# Set environment variables (never commit these)
export TF_VAR_session_secret="$(openssl rand -base64 32)"
Run the authentication script to get your subscription ID:

```sh
bash azure/scripts/setup-azure-auth.sh
```

⚠️ **IMPORTANT:** You must manually export the ARM_SUBSCRIPTION_ID variable in your shell before running Terraform:

```sh
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```
export TF_VAR_ssl_certificate_password="your-cert-password"
```

### 2. Azure Key Vault References
Use Key Vault references for sensitive data:
```hcl
ssl_certificate_data = "@Microsoft.KeyVault(VaultName=kv-name;SecretName=ssl-cert)"
ssl_certificate_password = "@Microsoft.KeyVault(VaultName=kv-name;SecretName=ssl-cert-password)"
```

### 3. Terraform Sensitive Variables
Always mark sensitive variables:
```hcl
variable "session_secret" {
  description = "Session secret"
  type        = string
  sensitive   = true  # Important!
}
```

### 4. Secure Configuration File
Create `terraform.tfvars.local` (gitignored):
```hcl
# terraform.tfvars.local (this file is gitignored)
session_secret = "actual-secret-value"
api_management_publisher_email = "actual-email@company.com"
```

## Security Checklist

### Before Committing:
- [ ] No hard-coded passwords or secrets
- [ ] All sensitive variables marked with `sensitive = true`
- [ ] Environment-specific secrets in `.env.local` files
- [ ] Personal information removed (emails, names)
- [ ] SAS tokens and connection strings externalized
- [ ] CORS origins restricted (no wildcards)

### Code Review Security Checks:
- [ ] Scan for patterns: `password =`, `secret =`, `key =`
- [ ] Check for email patterns: `@company.com`
- [ ] Verify SAS token patterns: `sp=`, `st=`, `sig=`
- [ ] Ensure Key Vault usage for production secrets
- [ ] Validate CORS configurations

## Secure Deployment Process

### 1. Pre-commit Hooks
The `.pre-commit-config.yaml` includes security checks:
- **Checkov** scans for security issues
- **terraform-docs** auto-generates documentation
- **terraform-fmt** ensures consistent formatting

### 2. Environment-Specific Secrets
```bash
# Development
cp .env.example .env.dev
# Fill in development values in .env.dev

# Production  
cp .env.example .env.prod
# Fill in production values in .env.prod
```

### 3. CI/CD Security
Use GitHub Secrets or Azure DevOps Variable Groups:
- `ARM_SUBSCRIPTION_ID`
- `ARM_CLIENT_ID` 
- `ARM_CLIENT_SECRET`
- `ARM_TENANT_ID`

## Common Security Anti-Patterns to Avoid

### ❌ **Don't Do This:**
```hcl
# DON'T: Hard-coded secrets
session_secret = "my-super-secret-123"
## Connection strings are deprecated for Cosmos DB access. Use Azure RBAC and managed identities instead.

# DON'T: Personal information
publisher_email = "john.doe@company.com"

# DON'T: Wildcard CORS
allowed_origins = ["*"]

# DON'T: SAS tokens in code
storage_url = "https://sa.blob.core.windows.net/container/file.zip?sp=r&st=2024..."
```

### ✅ **Do This Instead:**
```hcl
# DO: Environment variables
session_secret = var.session_secret

# DO: Key Vault references  
## Connection strings from Key Vault are deprecated for Cosmos DB. Use RBAC and managed identities for secure access.

# DO: Generic contact
publisher_email = var.api_management_publisher_email

# DO: Specific CORS origins
allowed_origins = [
  "https://dev.kainoscore.com",
  "https://staging.kainoscore.com"
]

# DO: Reference deployment packages without tokens
core_function_package_url = var.core_function_package_url
```

## Emergency Response

### If Secrets Are Accidentally Committed:
1. **Immediately rotate** all exposed credentials
2. **Force push** to remove from Git history:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/secret/file' \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Update** all environments with new credentials
4. **Review** access logs for potential unauthorized usage

## Security Tools Integration

### Pre-commit Security Scanning:
```bash
# Install pre-commit hooks
pre-commit install

# Run security checks manually
pre-commit run checkov --all-files
```

### Azure Security Center:
- Enable security recommendations
- Set up security alerts
- Regular vulnerability assessments

This document should be reviewed quarterly and updated as security practices evolve.
