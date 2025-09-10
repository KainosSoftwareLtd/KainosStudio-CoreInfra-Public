module "cosmos_db" {
  source              = "../modules/cosmodb"
  cosmos_account_name = local.cosmos_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  consistency_level   = "Session"
  geo_locations = [
    {
      location          = var.location
      failover_priority = 0
      zone_redundant    = false
    }
  ]

  database_name              = local.cosmos_database_name
  database_throughput        = var.cosmos_throughput
  database_autoscale_enabled = false
  containers = [
    {
      name                  = local.cosmos_container_name
      partition_key_path    = "/form_id"
      partition_key_version = 1
      autoscale_enabled     = false
      max_throughput        = 4000
      throughput            = 400
      indexing_mode         = "consistent"
      included_paths        = ["/*"]
      excluded_paths        = ["/\"_etag\"/?"]
      unique_keys           = ["/session_id"]
      default_ttl           = 3600
    }
  ]
  public_network_access_enabled = true
  free_tier_enabled             = true
  backup_enabled                = false
  tags                          = local.tags
}
