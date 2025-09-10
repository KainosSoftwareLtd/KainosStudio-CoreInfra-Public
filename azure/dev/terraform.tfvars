env                            = "dev"
location                       = "UK South"
resource_group_name            = "kainoscore-dev-rg"
auth_config_file_name          = "auth"
function_app_sku               = "Y1"
log_retention_days             = 30
cosmos_throughput              = 400
api_management_sku             = "Developer_1"
api_management_publisher_name  = "KainosStudio"
api_management_publisher_email = "kainosstudio@kainos.com"
enable_private_endpoints       = false
allowed_origins = [
  "http://localhost:3000",
  "https://kainoscore-cosmosdb-dev.documents.azure.com",
]