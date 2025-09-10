terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = var.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind

  # Consistency policy
  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.max_interval_in_seconds
    max_staleness_prefix    = var.max_staleness_prefix
  }

  # Geo location
  dynamic "geo_location" {
    for_each = var.geo_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  # Backup policy
  dynamic "backup" {
    for_each = var.backup_enabled ? [1] : []
    content {
      type                = var.backup_type
      interval_in_minutes = var.backup_interval_in_minutes
      retention_in_hours  = var.backup_retention_in_hours
      storage_redundancy  = var.backup_storage_redundancy
    }
  }

  # Capabilities
  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
  }

  # Virtual network rules
  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules
    content {
      id                                   = virtual_network_rule.value.subnet_id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  #   # IP range filter
  #   ip_range_filter = var.ip_range_filter

  # Access key metadata writes
  access_key_metadata_writes_enabled = var.access_key_metadata_writes_enabled

  # Public network access
  public_network_access_enabled = var.public_network_access_enabled

  # Analytical storage
  analytical_storage_enabled = var.analytical_storage_enabled

  # Free tier
  free_tier_enabled = var.free_tier_enabled

  tags = var.tags
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name

  # Throughput configuration
  dynamic "autoscale_settings" {
    for_each = var.database_autoscale_enabled ? [1] : []
    content {
      max_throughput = var.database_max_throughput
    }
  }

  throughput = var.database_autoscale_enabled ? null : var.database_throughput
}

# Cosmos DB SQL Container
resource "azurerm_cosmosdb_sql_container" "container" {
  count               = length(var.containers)
  name                = var.containers[count.index].name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.database.name

  partition_key_paths   = [var.containers[count.index].partition_key_path]
  partition_key_version = var.containers[count.index].partition_key_version

  # Throughput configuration
  dynamic "autoscale_settings" {
    for_each = var.containers[count.index].autoscale_enabled ? [1] : []
    content {
      max_throughput = var.containers[count.index].max_throughput
    }
  }

  throughput = var.containers[count.index].autoscale_enabled ? null : var.containers[count.index].throughput

  # Indexing policy
  indexing_policy {
    indexing_mode = var.containers[count.index].indexing_mode

    dynamic "included_path" {
      for_each = var.containers[count.index].included_paths
      content {
        path = included_path.value
      }
    }

    dynamic "excluded_path" {
      for_each = var.containers[count.index].excluded_paths
      content {
        path = excluded_path.value
      }
    }
  }

  # Unique key policy
  dynamic "unique_key" {
    for_each = var.containers[count.index].unique_keys
    content {
      paths = [unique_key.value]
    }
  }

  # Default TTL
  default_ttl = var.containers[count.index].default_ttl
}

# Private Endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmos_pe" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.cosmos_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.cosmos_account_name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmos.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  tags = var.tags
}
