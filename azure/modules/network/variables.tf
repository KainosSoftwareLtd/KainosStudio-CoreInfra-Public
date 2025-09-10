variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "app_gateway_subnet_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
  default     = "appgateway-subnet"
}

variable "app_gateway_subnet_prefixes" {
  description = "Address prefixes for the Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
