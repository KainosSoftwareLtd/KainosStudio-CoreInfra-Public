<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.38.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.38.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core_function_app"></a> [core\_function\_app](#module\_core\_function\_app) | ../modules/function-app | n/a |
| <a name="module_cosmos_db"></a> [cosmos\_db](#module\_cosmos\_db) | ../modules/cosmodb | n/a |
| <a name="module_form_data_storage"></a> [form\_data\_storage](#module\_form\_data\_storage) | ../modules/storage | n/a |
| <a name="module_kfd_api_function_app"></a> [kfd\_api\_function\_app](#module\_kfd\_api\_function\_app) | ../modules/function-app | n/a |
| <a name="module_kfd_storage"></a> [kfd\_storage](#module\_kfd\_storage) | ../modules/storage | n/a |
| <a name="module_static_storage"></a> [static\_storage](#module\_static\_storage) | ../modules/storage | n/a |
| <a name="module_zip_storage"></a> [zip\_storage](#module\_zip\_storage) | ../modules/storage | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_endpoint.fd_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin.function_origin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin.static_origin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.function_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_origin_group.static_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.fd_profile](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.assets_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_route.public_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_route.root_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule.static_cache_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule) | resource |
| [azurerm_cdn_frontdoor_rule_set.static_cache_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_service_plan.shared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_application_insights.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.session_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [terraform_remote_state.global](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_http_cdn"></a> [allow\_http\_cdn](#input\_allow\_http\_cdn) | Allow HTTP traffic on CDN (not recommended for production) | `bool` | `false` | no |
| <a name="input_allowed_origins"></a> [allowed\_origins](#input\_allowed\_origins) | CORS allowed origins | `list(string)` | <pre>[<br/>  "https://dev.kainoscore.com",<br/>  "http://localhost:3000"<br/>]</pre> | no |
| <a name="input_api_management_publisher_email"></a> [api\_management\_publisher\_email](#input\_api\_management\_publisher\_email) | API Management publisher email address | `string` | `"admin@kainos.com"` | no |
| <a name="input_api_management_publisher_name"></a> [api\_management\_publisher\_name](#input\_api\_management\_publisher\_name) | API Management publisher organization name | `string` | `"Kainos"` | no |
| <a name="input_api_management_sku"></a> [api\_management\_sku](#input\_api\_management\_sku) | API Management SKU | `string` | `"Developer_1"` | no |
| <a name="input_auth_config_file_name"></a> [auth\_config\_file\_name](#input\_auth\_config\_file\_name) | Auth configuration file name | `string` | `"auth-config.json"` | no |
| <a name="input_cdn_custom_domain"></a> [cdn\_custom\_domain](#input\_cdn\_custom\_domain) | Custom domain for CDN endpoint | `string` | `null` | no |
| <a name="input_cdn_sku"></a> [cdn\_sku](#input\_cdn\_sku) | SKU for the CDN profile | `string` | `"Standard_Microsoft"` | no |
| <a name="input_core_function_package_url"></a> [core\_function\_package\_url](#input\_core\_function\_package\_url) | Core Function App package URL (with SAS) | `string` | `null` | no |
| <a name="input_cosmos_throughput"></a> [cosmos\_throughput](#input\_cosmos\_throughput) | Cosmos DB throughput | `number` | `400` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name for the application | `string` | `"dev.kainoscore.com"` | no |
| <a name="input_enable_cdn_custom_domain"></a> [enable\_cdn\_custom\_domain](#input\_enable\_cdn\_custom\_domain) | Enable custom domain for CDN (requires certificate) | `bool` | `false` | no |
| <a name="input_enable_function_blob_deployment"></a> [enable\_function\_blob\_deployment](#input\_enable\_function\_blob\_deployment) | Deployment of function code now handled solely via CI/CD zip deploy | `bool` | `false` | no |
| <a name="input_enable_private_endpoints"></a> [enable\_private\_endpoints](#input\_enable\_private\_endpoints) | Enable private endpoints for services | `bool` | `false` | no |
| <a name="input_enable_static_cdn"></a> [enable\_static\_cdn](#input\_enable\_static\_cdn) | Enable CDN for static content | `bool` | `false` | no |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Enable Web Application Firewall | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | `"dev"` | no |
| <a name="input_function_app_sku"></a> [function\_app\_sku](#input\_function\_app\_sku) | SKU for Function App Service Plan | `string` | `"Y1"` | no |
| <a name="input_kfd_delete_function_package_url"></a> [kfd\_delete\_function\_package\_url](#input\_kfd\_delete\_function\_package\_url) | Delete Function package URL | `string` | `null` | no |
| <a name="input_kfd_upload_function_package_url"></a> [kfd\_upload\_function\_package\_url](#input\_kfd\_upload\_function\_package\_url) | Upload Function package URL | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region location | `string` | n/a | yes |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log retention in days | `number` | n/a | yes |
| <a name="input_nodejs_version"></a> [nodejs\_version](#input\_nodejs\_version) | Node.js version for Function Apps | `string` | `"22"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_session_secret"></a> [session\_secret](#input\_session\_secret) | Session secret for the application (can be a random UUID for development) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_cdn_fqdn"></a> [api\_cdn\_fqdn](#output\_api\_cdn\_fqdn) | API CDN endpoint FQDN |
| <a name="output_api_cdn_url"></a> [api\_cdn\_url](#output\_api\_cdn\_url) | Primary API CDN URL |
| <a name="output_cdn_profile_name"></a> [cdn\_profile\_name](#output\_cdn\_profile\_name) | CDN Profile name |
| <a name="output_core_function_app_principal_id"></a> [core\_function\_app\_principal\_id](#output\_core\_function\_app\_principal\_id) | Principal ID of the system-assigned managed identity for the Core Function App |
| <a name="output_core_function_app_url"></a> [core\_function\_app\_url](#output\_core\_function\_app\_url) | Core Function App URL |
| <a name="output_cosmos_db_endpoint"></a> [cosmos\_db\_endpoint](#output\_cosmos\_db\_endpoint) | Cosmos DB endpoint |
| <a name="output_cosmosdb_account_id"></a> [cosmosdb\_account\_id](#output\_cosmosdb\_account\_id) | Resource ID of the Cosmos DB Account |
| <a name="output_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#output\_cosmosdb\_account\_name) | Name of the Cosmos DB Account |
| <a name="output_form_data_storage_account_id"></a> [form\_data\_storage\_account\_id](#output\_form\_data\_storage\_account\_id) | Resource ID of the Form Data Storage Account |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Resource ID of the Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | Key Vault URI |
| <a name="output_kfd_api_function_app_principal_id"></a> [kfd\_api\_function\_app\_principal\_id](#output\_kfd\_api\_function\_app\_principal\_id) | Principal ID of the system-assigned managed identity for the KFD API Function App |
| <a name="output_kfd_storage_account_id"></a> [kfd\_storage\_account\_id](#output\_kfd\_storage\_account\_id) | Resource ID of the KFD Storage Account |
| <a name="output_kfd_storage_account_name"></a> [kfd\_storage\_account\_name](#output\_kfd\_storage\_account\_name) | KFD Storage Account name |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | Resource ID of the Log Analytics Workspace |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | Resource ID of the resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name |
| <a name="output_static_cdn_url"></a> [static\_cdn\_url](#output\_static\_cdn\_url) | Static content CDN endpoint URL |
| <a name="output_static_storage_account_id"></a> [static\_storage\_account\_id](#output\_static\_storage\_account\_id) | Resource ID of the Static Storage Account |
| <a name="output_static_storage_account_name"></a> [static\_storage\_account\_name](#output\_static\_storage\_account\_name) | Static Storage Account name |
| <a name="output_zip_storage_account_id"></a> [zip\_storage\_account\_id](#output\_zip\_storage\_account\_id) | Resource ID of the Zip Storage Account |
<!-- END_TF_DOCS -->
