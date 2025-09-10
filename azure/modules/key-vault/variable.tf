variable "key_vault_name" {
  description = "Name of the Key Vault"
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
  description = "SKU name for Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection. Recommended for production environments."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access. Defaults to false for security. Set to true only for development scenarios."
  type        = bool
  default     = false
}

variable "network_acls_enabled" {
  description = "Enable network ACLs"
  type        = bool
  default     = false
}

variable "network_acls_bypass" {
  description = "Network ACLs bypass"
  type        = string
  default     = "AzureServices"
}

variable "network_acls_default_action" {
  description = "Network ACLs default action"
  type        = string
  default     = "Allow"
}

variable "network_acls_ip_rules" {
  description = "Network ACLs IP rules"
  type        = list(string)
  default     = []
}

variable "network_acls_virtual_network_subnet_ids" {
  description = "Network ACLs virtual network subnet IDs"
  type        = list(string)
  default     = []
}

variable "access_policies" {
  description = "Additional access policies"
  type = list(object({
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  default = []
}

variable "secrets" {
  description = "Key Vault secrets"
  type = list(object({
    name         = string
    value        = string
    content_type = string
  }))
  default   = []
  sensitive = true
}

variable "keys" {
  description = "Key Vault keys"
  type = list(object({
    name     = string
    key_type = string
    key_size = number
    key_opts = list(string)
  }))
  default = []
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
