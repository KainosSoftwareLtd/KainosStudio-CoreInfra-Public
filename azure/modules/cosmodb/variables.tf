variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account"
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

variable "offer_type" {
  description = "Cosmos DB offer type"
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Cosmos DB kind"
  type        = string
  default     = "GlobalDocumentDB"
}

variable "consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"
}

variable "max_interval_in_seconds" {
  description = "Max interval in seconds for consistency"
  type        = number
  default     = 300
}

variable "max_staleness_prefix" {
  description = "Max staleness prefix for consistency"
  type        = number
  default     = 100000
}

variable "geo_locations" {
  description = "List of geo locations for Cosmos DB"
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
  }))
}

variable "backup_enabled" {
  description = "Enable backup for Cosmos DB"
  type        = bool
  default     = true
}

variable "backup_type" {
  description = "Backup type"
  type        = string
  default     = "Periodic"
}

variable "backup_interval_in_minutes" {
  description = "Backup interval in minutes"
  type        = number
  default     = 240
}

variable "backup_retention_in_hours" {
  description = "Backup retention in hours"
  type        = number
  default     = 8
}

variable "backup_storage_redundancy" {
  description = "Backup storage redundancy"
  type        = string
  default     = "Geo"
}

variable "capabilities" {
  description = "List of capabilities to enable"
  type        = list(string)
  default     = []
}

variable "virtual_network_rules" {
  description = "Virtual network rules"
  type = list(object({
    subnet_id                            = string
    ignore_missing_vnet_service_endpoint = bool
  }))
  default = []
}

variable "ip_range_filter" {
  description = "IP range filter"
  type        = string
  default     = ""
}

variable "access_key_metadata_writes_enabled" {
  description = "Enable access key metadata writes"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access. Defaults to false for security. Set to true only for development scenarios."
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "Enable analytical storage"
  type        = bool
  default     = false
}

variable "free_tier_enabled" {
  description = "Enable free tier"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_autoscale_enabled" {
  description = "Enable autoscale for database"
  type        = bool
  default     = false
}

variable "database_max_throughput" {
  description = "Max throughput for database autoscale"
  type        = number
  default     = 4000
}

variable "database_throughput" {
  description = "Database throughput"
  type        = number
  default     = 400
}

variable "containers" {
  description = "List of containers to create"
  type = list(object({
    name                  = string
    partition_key_path    = string
    partition_key_version = number
    autoscale_enabled     = bool
    max_throughput        = number
    throughput            = number
    indexing_mode         = string
    included_paths        = list(string)
    excluded_paths        = list(string)
    unique_keys           = list(string)
    default_ttl           = number
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
