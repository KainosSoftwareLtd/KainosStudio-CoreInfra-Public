variable "storage_account_name" {
  description = "Name of the storage account"
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

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "containers" {
  description = "List of containers to create"
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = true
}

variable "delete_retention_days" {
  description = "Blob delete retention days"
  type        = number
  default     = 7
}

variable "container_delete_retention_days" {
  description = "Container delete retention days"
  type        = number
  default     = 7
}

variable "shared_access_key_enabled" {
  description = "Enable shared access keys"
  type        = bool
  default     = true
}

variable "network_rules_enabled" {
  description = "Enable network access rules"
  type        = bool
  default     = false
}

variable "default_action" {
  description = "Default network access action"
  type        = string
  default     = "Allow"
}

variable "bypass" {
  description = "Network rules bypass"
  type        = list(string)
  default     = ["AzureServices"]
}

variable "ip_rules" {
  description = "List of IP rules"
  type        = list(string)
  default     = []
}

variable "virtual_network_subnet_ids" {
  description = "List of virtual network subnet IDs"
  type        = list(string)
  default     = []
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "customer_managed_key_id" {
  description = "Customer managed key ID"
  type        = string
  default     = null
}

variable "customer_managed_key_name" {
  description = "Customer managed key name"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
  default     = null
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle management policy"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle management rules"
  type = list(object({
    name                       = string
    enabled                    = bool
    prefix_match               = list(string)
    blob_types                 = list(string)
    tier_to_cool_after_days    = number
    tier_to_archive_after_days = number
    delete_after_days          = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_static_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "error_404_document" {
  description = "Error 404 document for static website"
  type        = string
  default     = "404.html"
}

variable "cors_rules" {
  description = "CORS rules for the storage account"
  type = list(object({
    allowed_origins    = list(string)
    allowed_methods    = list(string)
    allowed_headers    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}
