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

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "KainosStudio"
    Service     = "Kainoscore"
    Provider    = "azure"
    Owner       = "Terraform"
    Environment = "rbac"
  }
}
