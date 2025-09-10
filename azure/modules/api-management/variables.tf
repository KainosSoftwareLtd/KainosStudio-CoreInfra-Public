variable "api_management_name" {
  description = "Name of the API Management service"
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

variable "publisher_name" {
  description = "Publisher name for API Management"
  type        = string
  default     = "Kainos"
}

variable "publisher_email" {
  description = "Publisher email for API Management"
  type        = string
  default     = "admin@kainos.com"
}

variable "sku_name" {
  description = "SKU name for API Management"
  type        = string
  default     = "Developer_1"
}

variable "virtual_network_type" {
  description = "Virtual network type for API Management"
  type        = string
  default     = "None"
}

variable "subnet_id" {
  description = "Subnet ID for API Management VNet integration"
  type        = string
  default     = null
}

variable "core_function_url" {
  description = "Core Function App URL"
  type        = string
}

variable "kfd_upload_function_url" {
  description = "KFD Upload Function App URL"
  type        = string
}

variable "kfd_delete_function_url" {
  description = "KFD Delete Function App URL"
  type        = string
}

variable "core_function_key" {
  description = "Core Function App key"
  type        = string
  default     = null
  sensitive   = true
}

variable "kfd_upload_function_key" {
  description = "KFD Upload Function App key"
  type        = string
  default     = null
  sensitive   = true
}

variable "kfd_delete_function_key" {
  description = "KFD Delete Function App key"
  type        = string
  default     = null
  sensitive   = true
}

variable "allowed_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default     = ["*"]
}

variable "custom_domain" {
  description = "Custom domain for API Management"
  type        = string
  default     = null
}

variable "ssl_certificate_key_vault_secret_id" {
  description = "Key Vault secret ID for SSL certificate"
  type        = string
  default     = null
}

variable "certificates" {
  description = "List of certificates for API Management"
  type = list(object({
    encoded_certificate  = string
    certificate_password = string
    store_name           = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
