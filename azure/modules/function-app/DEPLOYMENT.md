# Function App Deployment Guide

This module creates Azure Function Apps with a hybrid deployment pattern that separates infrastructure from application code.

## Deployment Pattern

### Infrastructure (Terraform)
- Function App resource and configuration
- App Service Plan
- Application Insights
- Core app settings (connection strings, runtime settings)

### Application Code (Separate Deployment)
- Function code and bindings
- Package deployments via:
  - Azure CLI: `az functionapp deployment source config-zip`
  - VS Code Azure Functions extension
  - GitHub Actions / Azure DevOps
  - Direct zip deployment

## Important Settings

### Managed by Terraform
- `FUNCTIONS_WORKER_RUNTIME`
- `WEBSITE_NODE_DEFAULT_VERSION`
- Application Insights connection
- Custom app settings defined in variables

### Managed by Deployment Tools
- `WEBSITE_RUN_FROM_PACKAGE` (set by CI/CD with package URL)
- `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING` (added by Azure)
- `WEBSITE_CONTENTSHARE` (added by Azure)
- `SCM_TYPE` (may change based on deployment method)

## Lifecycle Management

The Function App resource uses `ignore_changes` to prevent Terraform from overwriting settings that are managed by deployment tools. This allows you to:

1. Deploy functions without Terraform removing them
2. Use different deployment methods without conflicts
3. Let Azure manage deployment-specific settings

## Best Practices

1. **Always deploy infrastructure first** with Terraform
2. **Deploy function code separately** using your preferred method
3. **Don't include function code or packages** in Terraform state
4. **Use consistent app settings** - define them in Terraform variables
5. **Monitor deployments** through Application Insights (configured automatically)

## Troubleshooting

If functions disappear after `terraform apply`:
- Check that the `ignore_changes` block includes the relevant settings
- Verify that deployment tools aren't conflicting with Terraform-managed settings
- Review Application Insights logs for deployment issues
