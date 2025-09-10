module "kfd_storage" {
  source               = "../modules/storage"
  storage_account_name = local.storage_kfd_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  account_tier         = "Standard"
  replication_type     = "LRS"
  containers = [
    {
      name        = "kfd-files"
      access_type = "private"
    }
  ]
  enable_versioning     = true
  delete_retention_days = 7
  tags                  = local.tags
}

module "static_storage" {
  source               = "../modules/storage"
  storage_account_name = local.storage_static_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  account_tier         = "Standard"
  replication_type     = "LRS"
  containers = [
    {
      name        = "static-files"
      access_type = "private"
    }
  ]
  enable_static_website = true
  index_document        = "index.html"
  error_404_document    = "404.html"
  enable_versioning     = false
  tags                  = local.tags
}

module "form_data_storage" {
  source = "../modules/storage"

  storage_account_name = local.storage_form_data_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  account_tier         = "Standard"
  replication_type     = "LRS"
  containers = [
    {
      name        = "submitted-forms"
      access_type = "private"
    }
  ]
  enable_versioning     = true
  delete_retention_days = 30
  cors_rules = [
    {
      allowed_origins = [
        "https://${var.domain}",
        "https://${azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name}",
        "https://${module.core_function_app.function_app_hostname}",
        "http://localhost:3000"
      ]
      allowed_methods    = ["PUT", "OPTIONS"]
      allowed_headers    = ["*"]
      exposed_headers    = [""]
      max_age_in_seconds = 3600
    }
  ]
  tags = local.tags
}

module "zip_storage" {
  source               = "../modules/storage"
  storage_account_name = local.storage_zip_files_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  account_tier         = "Standard"
  replication_type     = "LRS"
  containers = [
    {
      name        = "deployments"
      access_type = "private"
    }
  ]
  enable_versioning = false
  tags              = local.tags
}
