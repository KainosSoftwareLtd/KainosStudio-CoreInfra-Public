# Azure Makefile Usage Guide

## Overview

The Azure Makefile has been updated to work like the AWS Makefile - it's now located in the `azure/` directory (not `azure/dev/`) and supports multiple environments with the format `make <action> <environment>`.

## Location

```
azure/
├── Makefile          # ← Main Makefile (NEW)
├── dev/
├── staging/
├── prod/
├── global/
├── rbac/
└── modules/
```

## Usage Pattern

```bash
make <action> <environment>
```

## Available Actions

- `init` - Initialize Terraform and pre-commit dependencies
- `plan` - Create Terraform plan
- `apply` - Apply Terraform changes using the plan
- `destroy` - Destroy Terraform infrastructure
- `fmt` - Format Terraform files
- `validate` - Validate Terraform configuration
- `checkov` - Run Checkov security scan
- `check` - Run fmt, validate, and Checkov scan
- `test` - Run deployment tests
- `pre-commit-install` - Install pre-commit hooks
- `pre-commit-run` - Run pre-commit hooks

## Available Environments

- `dev` - Development environment (default)
- `staging` - Staging environment
- `prod` - Production environment
- `global` - Global resources
- `rbac` - RBAC resources

## Examples

### Complete Deployment Workflow
```bash
cd azure

# Step 1: Validate all environments
./scripts/validate-all.sh

# Step 2: Deploy infrastructure in order (dependencies matter)
make plan global && make apply global    # Deploy shared resources first
make plan rbac && make apply rbac        # Deploy role assignments second
make plan dev && make apply dev          # Deploy environment resources last

# Step 3: Test deployment
./scripts/test-deployment.sh
```

### Development Workflow
```bash
cd azure

# Initialize dev environment
make init dev

# Create plan for dev
make plan dev

# Apply changes to dev
make apply dev

# Run tests
make test dev
```

### Multi-Environment Operations
```bash
# Format all environments
make fmt dev
make fmt staging
make fmt prod
make fmt global
make fmt rbac

# Validate all environments
make validate dev
make validate staging
make validate prod

# Check all environments (fmt + validate + checkov)
make check dev
make check staging
make check prod
```

### Pre-commit and Code Quality
```bash
# Install pre-commit hooks (once)
make pre-commit-install

# Run pre-commit on all files
make pre-commit-run

# Format specific environment
make fmt dev
```

### Testing Deployment
```bash
# Test deployment (requires deployed infrastructure)
make test dev
```

## Key Improvements

1. **Consistent with AWS**: Same pattern as `aws/Makefile`
2. **Single Location**: One Makefile for all environments
3. **Environment Validation**: Checks if environment directory exists
4. **Better Error Handling**: Clear error messages for missing files/directories
5. **Flexible**: Easy to add new environments or actions

## Migration from Old Makefile

**Before** (old way):
```bash
cd azure/dev
make init
make plan
make apply
```

**After** (new way):
```bash
cd azure
make init dev
make plan dev
make apply dev
```

## Testing the Makefile

```bash
# Test help
make help

# Test format (safe operation)
make fmt dev

# Test validation (safe operation)
make validate dev

# Test with different environments
make fmt global
make validate rbac
```

## Error Scenarios

### Invalid Environment
```bash
make fmt invalid
# Output: Error handling -chdir option: no such file or directory
```

### Missing Plan File
```bash
make apply dev  # without running plan first
# Output: Error: No plan file found for dev. Run 'make plan dev' first
```

### No Deployment for Testing
```bash
make test dev  # without deployed infrastructure
# Output: ❌ No terraform state found. Please run 'terraform apply' first.
```

## Quick Commands Reference

| Action | Command | Description |
|--------|---------|-------------|
| Get help | `make help` | Show all available commands |
| Initialize | `make init dev` | Set up Terraform and pre-commit |
| Plan changes | `make plan dev` | Create execution plan |
| Apply changes | `make apply dev` | Deploy infrastructure |
| Format code | `make fmt dev` | Format Terraform files |
| Validate config | `make validate dev` | Validate Terraform syntax |
| Run all checks | `make check dev` | Format + validate + security scan |
| Test deployment | `make test dev` | Run deployment health checks |
| Destroy infra | `make destroy dev` | Destroy infrastructure (with confirmation) |

The new Makefile provides a much better developer experience and consistency with the AWS setup! 🎉
