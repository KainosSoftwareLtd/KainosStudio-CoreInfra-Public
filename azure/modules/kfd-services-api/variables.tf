variable "api_management_name" {
  description = "Name of the API Management service"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
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
