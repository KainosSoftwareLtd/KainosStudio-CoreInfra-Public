locals {
  resource_group_names = {
    for env in var.environments : env => "${var.project_name}-${env}-rg"
  }

  terraform_rg_name = var.terraform_state_resource_group_name

  # Resources
  key_vault_name     = "${var.project_name}-global-kvlt"
  log_analytics_name = "${var.project_name}-global-law"
  app_insights_name  = "${var.project_name}-global-ai"

  # Storage (globally unique)
  terraform_storage_name = var.terraform_state_storage_account_name
  shared_storage_name    = "${var.project_name}sharedsa"

  github_actions_sp_name = "${var.project_name}-github-actions-sp"

  # Tags
  common_tags = merge(var.tags, {
    ManagedBy = "Terraform"
    CreatedBy = "Github Actions"
  })

  environment_tags = {
    for env in var.environments : env => merge(local.common_tags, {
      Environment = env
    })
  }
}
