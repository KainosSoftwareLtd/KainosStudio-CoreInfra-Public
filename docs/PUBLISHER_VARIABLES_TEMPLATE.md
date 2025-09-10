# API Management Publisher Configuration Template
# Copy these variables to your environment's variables.tf file for consistency

# API Management Publisher Configuration
variable "api_management_publisher_name" {
  description = "API Management publisher organization name"
  type        = string
  default     = "Your Organization" # Update this for your organization
}

variable "api_management_publisher_email" {
  description = "API Management publisher email address"
  type        = string
  default     = "admin@yourorg.com" # Update this for your organization
}

# Example terraform.tfvars configuration:
# api_management_publisher_name  = "Kainos"
# api_management_publisher_email = "admin@kainos.com"
