variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "kainoscore"
}

variable "environments" {
  description = "List of environments"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
  default     = "KainosSoftwareLtd"
}

variable "github_repositories" {
  description = "GitHub repositories for CI/CD"
  type        = list(string)
  default = [
    "KainosStudio-CoreInfra",
    "KainosStudio-CoreApp"
  ]
}

variable "terraform_state_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "kainoscoreterraformsa"
}

variable "terraform_state_resource_group_name" {
  description = "Resource group name for Terraform state"
  type        = string
  default     = "kainoscore-terraform-rg"
}

variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 365
}

variable "key_vault_sku" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"
}

variable "enable_diagnostic_settings" {
  description = "Enable diagnostic settings for resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "KainosStudio"
    Service     = "Kainoscore"
    Provider    = "azure"
    Owner       = "Terraform"
    Environment = "global"
  }
}
