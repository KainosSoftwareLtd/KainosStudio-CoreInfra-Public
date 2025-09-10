variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "domain" {
  description = "Domain name for the application"
  type        = string
  default     = "dev.kainoscore.com"
}

variable "allowed_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default = [
    "https://dev.kainoscore.com",
    "http://localhost:3000"
  ]
}

variable "session_secret" {
  description = "Session secret for the application (can be a random UUID for development)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "auth_config_file_name" {
  description = "Auth configuration file name"
  type        = string
  default     = "auth-config.json"
}

variable "nodejs_version" {
  description = "Node.js version for Function Apps"
  type        = string
  default     = "22"
}

variable "function_app_sku" {
  description = "SKU for Function App Service Plan"
  type        = string
  default     = "Y1"
}

variable "enable_function_blob_deployment" {
  description = "Deployment of function code now handled solely via CI/CD zip deploy"
  type        = bool
  default     = false
}

variable "core_function_package_url" {
  description = "Core Function App package URL (with SAS)"
  type        = string
  default     = null
  sensitive   = true
}

variable "kfd_upload_function_package_url" {
  description = "Upload Function package URL"
  type        = string
  default     = null
}

variable "kfd_delete_function_package_url" {
  description = "Delete Function package URL"
  type        = string
  default     = null
}

variable "cosmos_throughput" {
  description = "Cosmos DB throughput"
  type        = number
  default     = 400
}

variable "api_management_sku" {
  description = "API Management SKU"
  type        = string
  default     = "Developer_1"
}

variable "api_management_publisher_name" {
  description = "API Management publisher organization name"
  type        = string
  default     = "Kainos"
}

variable "api_management_publisher_email" {
  description = "API Management publisher email address"
  type        = string
  default     = "admin@kainos.com"
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints for services"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region location"
  type        = string
}

variable "cdn_sku" {
  description = "SKU for the CDN profile"
  type        = string
  default     = "Standard_Microsoft"
}

variable "enable_static_cdn" {
  description = "Enable CDN for static content"
  type        = bool
  default     = false
}

variable "allow_http_cdn" {
  description = "Allow HTTP traffic on CDN (not recommended for production)"
  type        = bool
  default     = false
}

variable "cdn_custom_domain" {
  description = "Custom domain for CDN endpoint"
  type        = string
  default     = null
}

variable "enable_cdn_custom_domain" {
  description = "Enable custom domain for CDN (requires certificate)"
  type        = bool
  default     = false
}