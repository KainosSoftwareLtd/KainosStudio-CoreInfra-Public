# Environment Setup Guides

This folder contains comprehensive setup guides for each environment in the Kainos Studio infrastructure.

## 📋 Available Guides

- **[Development Setup](./DEV_SETUP.md)** - Complete development environment setup
- **[Staging Setup](./STAGING_SETUP.md)** - Staging environment configuration
- **[Production Setup](./PROD_SETUP.md)** - Production environment deployment

## 🎯 Quick Reference

### Prerequisites (All Environments)
- Terraform ~> 1.10.0
- Pre-commit hooks
- Cloud provider CLI (AWS/Azure)
- Node.js for function development

### Common Commands
```bash
# Initialize environment
make init <environment>

# Plan changes
make plan <environment>

# Apply changes
make apply <environment>

# Validate configuration
make check
```

## 📚 Cross-References

These guides reference the following as source of truth:
- **[Terraform AWS Modules](../../aws/modules/)** - AWS infrastructure blueprints
- **[Terraform Azure Modules](../../azure/modules/)** - Azure infrastructure blueprints
- **[Main README](../../README.md)** - Project overview and prerequisites

## 🔄 Environment Progression

1. **Development** → Local testing and feature development
2. **Staging** → Integration testing and UAT
3. **Production** → Live environment with full monitoring

Each environment builds upon the previous with additional security, monitoring, and approval requirements.
