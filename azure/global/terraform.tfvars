# Global Environment Configuration

# Project settings
project_name = "kainoscore"
location     = "uksouth"

# Disable diagnostic settings temporarily to avoid conflicts
enable_diagnostic_settings = false

# Key Vault settings
key_vault_sku = "standard"

# Log retention
log_retention_days = 30

# Environments to support
environments = ["dev"]

# GitHub settings (commented out for local deployment)
# github_organization = "KainosSoftwareLtd"
# github_repositories = ["KainosStudio-CoreInfra"]

# State storage (if needed)
terraform_state_storage_account_name = "kainoscorestate2025"
terraform_state_resource_group_name  = "kainoscore-terraform-rg"

# Tags
tags = {
  Project     = "KainosCore"
  Environment = "Global"
  ManagedBy   = "Terraform"
  Repository  = "KainosStudio-CoreInfra"
}
