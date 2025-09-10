locals {
  storage_kfd_name         = "kainoscorekfd${var.env}"
  storage_static_name      = "kainoscorestatic${var.env}"
  storage_form_data_name   = "kainoscoreformdata${var.env}"
  storage_zip_files_name   = "kainoscorezip${var.env}"
  storage_audit_logs_name  = "kainoscoreaudit${var.env}"
  core_function_name       = "kainoscore-app-${var.env}"
  kfd_api_function_name    = "kainoscore-kfd-api-${var.env}"
  app_service_plan_name    = "kainoscore-asp-${var.env}"
  cosmos_account_name      = "kainoscore-cosmosdb-${var.env}"
  cosmos_database_name     = "KainoscoreDB"
  cosmos_container_name    = "FormSessions"
  api_management_name      = "kainoscore-api-${var.env}"
  cdn_profile_name         = "kainoscore-cdn-${var.env}"
  api_cdn_endpoint_name    = "kainoscore-api-${var.env}"
  static_cdn_endpoint_name = "kainoscore-static-${var.env}"
  vnet_name                = "kainoscore-vnet-${var.env}"
  global_key_vault_id      = try(data.terraform_remote_state.global.outputs.key_vault_id, null)
  global_key_vault_name    = try(data.terraform_remote_state.global.outputs.key_vault_name, null)
  global_log_analytics_id  = try(data.terraform_remote_state.global.outputs.log_analytics_workspace_id, null)
  global_app_insights_id   = try(data.terraform_remote_state.global.outputs.application_insights_id, null)
  tags = {
    Environment = var.env
    Project     = "KainosStudio"
    Service     = "Kainoscore"
    Provider    = "azure"
    Owner       = "Terraform"
  }
}
