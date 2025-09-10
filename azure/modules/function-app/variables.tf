variable "storage_account_id" {
  description = "Resource ID of the Storage Account for RBAC assignment"
  type        = string
}

variable "use_external_service_plan" {
  description = "Whether to use an external service plan instead of creating a new one"
  type        = bool
  default     = false
}

variable "service_plan_id" {
  description = "External service plan ID (required when use_external_service_plan is true)"
  type        = string
  default     = null
}

variable "cosmosdb_account_id" {
  description = "Resource ID of the Cosmos DB Account for RBAC assignment"
  type        = string
}
variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the service plan"
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "Storage account name for function app"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage account access key"
  type        = string
  sensitive   = true
}

variable "node_version" {
  description = "Node.js version for the function app"
  type        = string
  default     = "18"
}

variable "app_settings" {
  description = "Application settings for the function app"
  type        = map(string)
  default     = {}
}

variable "allowed_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default     = ["*"]
}

variable "logs_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 365
}

variable "package_url" {
  description = "Deployment package URL"
  type        = string
  default     = null
}

variable "deployment_storage_account_name" {
  description = "Storage account name for deployment packages (optional, separate from runtime storage)"
  type        = string
  default     = null
}

variable "deployment_container_name" {
  description = "Container name for deployment packages"
  type        = string
  default     = "deployment-packages"
}

variable "enable_blob_deployment" {
  description = "Enable blob deployment for function packages"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "Key Vault ID for secret access"
  type        = string
  default     = null
}

variable "global_application_insights_key" {
  description = "Global Application Insights instrumentation key"
  type        = string
  default     = null
}

variable "global_application_insights_connection_string" {
  description = "Global Application Insights connection string"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}