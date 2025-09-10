variable "cdn_profile_name" {
  description = "Name of the Azure CDN profile"
  type        = string
}

variable "location" {
  description = "Azure region where the CDN profile will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "cdn_sku" {
  description = "SKU for the CDN profile"
  type        = string
  default     = "Standard_Microsoft"
  validation {
    condition = contains([
      "Standard_Akamai",
      "Standard_Microsoft",
      "Standard_Verizon",
      "Premium_Verizon"
    ], var.cdn_sku)
    error_message = "CDN SKU must be one of: Standard_Akamai, Standard_Microsoft, Standard_Verizon, Premium_Verizon."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# API Endpoint Variables
variable "api_endpoint_name" {
  description = "Name of the API CDN endpoint"
  type        = string
}

variable "api_origin_host" {
  description = "Origin host for the API endpoint (e.g., API Management gateway)"
  type        = string
}

variable "api_origin_path" {
  description = "Origin path for the API endpoint"
  type        = string
  default     = ""
}

variable "allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

# Static Content Endpoint Variables
variable "enable_static_endpoint" {
  description = "Whether to create a static content endpoint"
  type        = bool
  default     = false
}

variable "static_endpoint_name" {
  description = "Name of the static content CDN endpoint"
  type        = string
  default     = ""
}

variable "static_origin_host" {
  description = "Origin host for static content (e.g., storage account)"
  type        = string
  default     = ""
}

variable "static_origin_path" {
  description = "Origin path for static content"
  type        = string
  default     = ""
}

# General Configuration
variable "optimization_type" {
  description = "Optimization type for the CDN endpoint"
  type        = string
  default     = "GeneralWebDelivery"
  validation {
    condition = contains([
      "GeneralWebDelivery",
      "GeneralMediaStreaming",
      "VideoOnDemandMediaStreaming",
      "LargeFileDownload",
      "DynamicSiteAcceleration"
    ], var.optimization_type)
    error_message = "Optimization type must be one of the supported CDN optimization types."
  }
}

variable "allow_http" {
  description = "Whether to allow HTTP traffic (not recommended for production)"
  type        = bool
  default     = false
}

variable "querystring_caching" {
  description = "Query string caching behavior"
  type        = string
  default     = "IgnoreQueryString"
  validation {
    condition = contains([
      "IgnoreQueryString",
      "BypassCaching",
      "UseQueryString"
    ], var.querystring_caching)
    error_message = "Query string caching must be one of: IgnoreQueryString, BypassCaching, UseQueryString."
  }
}

# Custom Domain (optional)
variable "custom_domain_name" {
  description = "Custom domain name for the CDN endpoint (optional)"
  type        = string
  default     = null
}

variable "enable_custom_domain" {
  description = "Enable custom domain configuration (requires certificate)"
  type        = bool
  default     = false
}
