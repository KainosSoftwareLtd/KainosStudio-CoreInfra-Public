<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.47.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.38.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.47.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.38.1 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | ../modules/key-vault | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.github_actions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.github_actions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_application_insights.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.environments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.global](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.shared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.deployment_packages](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.shared_artifacts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_password.session_secrets](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_diagnostic_settings"></a> [enable\_diagnostic\_settings](#input\_enable\_diagnostic\_settings) | Enable diagnostic settings for resources | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environments | `list(string)` | <pre>[<br/>  "dev",<br/>  "staging",<br/>  "prod"<br/>]</pre> | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization name | `string` | `"KainosSoftwareLtd"` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repositories for CI/CD | `list(string)` | <pre>[<br/>  "KainosStudio-CoreInfra",<br/>  "KainosStudio-CoreApp"<br/>]</pre> | no |
| <a name="input_key_vault_sku"></a> [key\_vault\_sku](#input\_key\_vault\_sku) | Key Vault SKU | `string` | `"standard"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for resources | `string` | `"UK South"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log retention in days | `number` | `365` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for naming resources | `string` | `"kainoscore"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "global",<br/>  "Owner": "Terraform",<br/>  "Project": "KainosStudio",<br/>  "Provider": "azure",<br/>  "Service": "Kainoscore"<br/>}</pre> | no |
| <a name="input_terraform_state_resource_group_name"></a> [terraform\_state\_resource\_group\_name](#input\_terraform\_state\_resource\_group\_name) | Resource group name for Terraform state | `string` | `"kainoscore-terraform-rg"` | no |
| <a name="input_terraform_state_storage_account_name"></a> [terraform\_state\_storage\_account\_name](#input\_terraform\_state\_storage\_account\_name) | Storage account name for Terraform state | `string` | `"kainoscoreterraformsa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_insights_connection_string"></a> [application\_insights\_connection\_string](#output\_application\_insights\_connection\_string) | Connection string for Application Insights |
| <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id) | ID of the global Application Insights |
| <a name="output_application_insights_instrumentation_key"></a> [application\_insights\_instrumentation\_key](#output\_application\_insights\_instrumentation\_key) | Instrumentation key for Application Insights |
| <a name="output_application_insights_name"></a> [application\_insights\_name](#output\_application\_insights\_name) | Name of the global Application Insights |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | Common tags for all resources |
| <a name="output_environment_tags"></a> [environment\_tags](#output\_environment\_tags) | Environment-specific tags |
| <a name="output_github_actions_application_id"></a> [github\_actions\_application\_id](#output\_github\_actions\_application\_id) | Application ID of the GitHub Actions service principal |
| <a name="output_github_actions_service_principal_id"></a> [github\_actions\_service\_principal\_id](#output\_github\_actions\_service\_principal\_id) | Object ID of the GitHub Actions service principal |
| <a name="output_global_resource_group_name"></a> [global\_resource\_group\_name](#output\_global\_resource\_group\_name) | Name of the global resource group |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | ID of the Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Key Vault |
| <a name="output_location"></a> [location](#output\_location) | Azure region location |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Name of the global Log Analytics workspace |
| <a name="output_resource_group_names"></a> [resource\_group\_names](#output\_resource\_group\_names) | Names of environment resource groups |
| <a name="output_shared_storage_account_id"></a> [shared\_storage\_account\_id](#output\_shared\_storage\_account\_id) | ID of the shared storage account |
| <a name="output_shared_storage_account_name"></a> [shared\_storage\_account\_name](#output\_shared\_storage\_account\_name) | Name of the shared storage account |
| <a name="output_terraform_resource_group_name"></a> [terraform\_resource\_group\_name](#output\_terraform\_resource\_group\_name) | Name of the Terraform resource group |
<!-- END_TF_DOCS -->
