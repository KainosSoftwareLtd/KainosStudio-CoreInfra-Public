# Kainos Studio Infrastructure Playbook

This playbook provides comprehensive documentation for the Kainos Studio Core Infrastructure project, covering deployment, security, networking, and operational procedures.

## 📁 Documentation Structure

- **[Infrastructure Diagrams](./diagrams/)** - End-to-end architecture and flow diagrams
- **[Environment Setup Guides](./setup/)** - Environment-specific deployment guides
- **[CI/CD Guide](./CICD_GUIDE.md)** - Workflows and GitHub Actions documentation
- **[Security Guides](./security/)** - Security configurations and best practices
- **[Networking Guide](./NETWORKING_GUIDE.md)** - VPC, subnetting, and connectivity details
- **[Infrastructure Requirements](./INFRASTRUCTURE_REQUIREMENTS.md)** - Minimum requirements and specifications
- **[Monitoring & Alerting](./MONITORING_ALERTING.md)** - Current monitoring and logging setup

## 🎯 Quick Start

1. Review the [Infrastructure Diagrams](./diagrams/) to understand the architecture
2. Follow the appropriate [Environment Setup Guide](./setup/) for your target environment
3. Configure security following the [Security Guides](./security/)
4. Set up monitoring using the [Monitoring & Alerting](./MONITORING_ALERTING.md) guide

## 📋 Prerequisites

- Terraform ~> 1.10.0
- AWS CLI (for AWS deployments)
- Azure CLI (for Azure deployments)
- Node.js (for function development)
- Pre-commit hooks installed

For detailed prerequisites, see the main [README](../README.md).
