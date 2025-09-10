# Terraform state resource group (may already exist)
resource "azurerm_resource_group" "terraform" {
  name     = local.terraform_rg_name
  location = var.location
  tags     = local.common_tags

  lifecycle {
    ignore_changes = [tags]
  }
}

# Environment-specific resource groups
resource "azurerm_resource_group" "environments" {
  for_each = toset(var.environments)

  name     = local.resource_group_names[each.key]
  location = var.location
  tags     = local.environment_tags[each.key]
}

# Global/shared resource group
resource "azurerm_resource_group" "global" {
  name     = "${var.project_name}-global-rg"
  location = var.location
  tags     = local.common_tags
}
