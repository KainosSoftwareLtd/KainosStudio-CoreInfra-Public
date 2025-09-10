<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.useast1"></a> [aws.useast1](#provider\_aws.useast1) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core_lambda"></a> [core\_lambda](#module\_core\_lambda) | ../modules/lambda | n/a |
| <a name="module_kfd_api_lambda"></a> [kfd\_api\_lambda](#module\_kfd\_api\_lambda) | ../modules/lambda | n/a |
| <a name="module_kfd_s3_bucket"></a> [kfd\_s3\_bucket](#module\_kfd\_s3\_bucket) | ../modules/s3 | n/a |
| <a name="module_observability_coreapp"></a> [observability\_coreapp](#module\_observability\_coreapp) | ../modules/observability | n/a |
| <a name="module_s3_core_audit_logs"></a> [s3\_core\_audit\_logs](#module\_s3\_core\_audit\_logs) | ../modules/s3 | n/a |
| <a name="module_s3_core_zip_files"></a> [s3\_core\_zip\_files](#module\_s3\_core\_zip\_files) | ../modules/s3 | n/a |
| <a name="module_static_s3_bucket"></a> [static\_s3\_bucket](#module\_static\_s3\_bucket) | ../modules/s3 | n/a |
| <a name="module_submitted_form_data"></a> [submitted\_form\_data](#module\_submitted\_form\_data) | ../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.account_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_deployment.core_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_deployment.kfd_deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_deployment.kfd_deployment_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.core_proxy_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.core_put_method_root_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.kfd_delete_method_services_id_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.kfd_delete_method_services_id_integration_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.kfd_put_method_root_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.kfd_put_method_root_integration_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.core_proxy_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.core_root_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.kfd_delete_method_services_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.kfd_delete_method_services_id_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.kfd_put_method_root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.kfd_put_method_root_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_settings.core_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_method_settings.kfd_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_method_settings.kfd_all_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_resource.core_proxy_resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.kfd_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.kfd_services_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.kfd_services_id_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.kfd_services_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.core_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_rest_api.kfd_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_rest_api.kfd_api_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_rest_api_policy.restrict_to_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) | resource |
| [aws_api_gateway_rest_api_policy.restrict_to_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) | resource |
| [aws_api_gateway_stage.core_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_stage.kfd_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_stage.kfd_stage_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudfront_cache_policy.s3_cache_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_cache_policy) | resource |
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudwatch_log_group.core_api_execution_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.core_api_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.kfd_api_execution_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.kfd_api_execution_log_group_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.kfd_api_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.kfd_api_log_group_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dynamodb_table.core_form_sessions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.api_gateway_logging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.api_gateway_logging_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.api_gateway_logging_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.core_apigw_lambda_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.core_apigw_lambda_get](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.kfd_delete_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.kfd_delete_trigger_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.kfd_upload_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.kfd_upload_trigger_regional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_acl.cloudfront_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_core_audit_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.static_files_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.gha_codebuild_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_kms_alias.cw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_kms_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_kms_alias.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.dev-codebuild_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.private_subnets_dev](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.dev_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_wafv2_web_acl.cloudfront_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/wafv2_web_acl) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_core_name"></a> [api\_core\_name](#input\_api\_core\_name) | API Gateway For Fabric/Kainos Core | `string` | `"kainoscore-api-"` | no |
| <a name="input_api_gateway_logging_role_name"></a> [api\_gateway\_logging\_role\_name](#input\_api\_gateway\_logging\_role\_name) | API Gateway Logging Role | `string` | `"kainoscore-api-gateway-logging-role"` | no |
| <a name="input_api_kfd_name"></a> [api\_kfd\_name](#input\_api\_kfd\_name) | API For KFD | `string` | `"kainoscore-kfd-services-"` | no |
| <a name="input_apigateway_vpc_endpoint"></a> [apigateway\_vpc\_endpoint](#input\_apigateway\_vpc\_endpoint) | API Gateway VPC Endpoint | `string` | n/a | yes |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | The ARN of the role to assume | `string` | `"arn:aws:iam::696793786584:role/GHA-CodeBuild-Service-Role"` | no |
| <a name="input_auth_config_file_name"></a> [auth\_config\_file\_name](#input\_auth\_config\_file\_name) | Name of the auth config file | `string` | `"auth"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | SSL Certificate Manager ARN | `string` | n/a | yes |
| <a name="input_cloudfront_access_control_name"></a> [cloudfront\_access\_control\_name](#input\_cloudfront\_access\_control\_name) | Name for the CloudFront Origin Access Control | `string` | `"Core-Access-Control-"` | no |
| <a name="input_cloudfront_s3_policy_name"></a> [cloudfront\_s3\_policy\_name](#input\_cloudfront\_s3\_policy\_name) | Name for the CloudFront S3 Cache Policy | `string` | `"Core-S3-Cache-Policy-"` | no |
| <a name="input_cloudfront_stage"></a> [cloudfront\_stage](#input\_cloudfront\_stage) | API stage to connect CloudFront to | `string` | `"/uat"` | no |
| <a name="input_core_lambda_alias"></a> [core\_lambda\_alias](#input\_core\_lambda\_alias) | Alias For Fabric/Core Lambda | `string` | `"CoreLambda"` | no |
| <a name="input_core_lambda_name"></a> [core\_lambda\_name](#input\_core\_lambda\_name) | Name of the Core Lambda function | `string` | `"kainoscore-app"` | no |
| <a name="input_core_stage"></a> [core\_stage](#input\_core\_stage) | API Gateway Stage For Fabric/Kainos Core | `string` | `"uat"` | no |
| <a name="input_creator"></a> [creator](#input\_creator) | Identifier for the creator of these resources | `string` | `"Terraform"` | no |
| <a name="input_dev_codebuild_security_group_id"></a> [dev\_codebuild\_security\_group\_id](#input\_dev\_codebuild\_security\_group\_id) | Dev ENV Codebuild Security Group ID | `string` | `"sg-0eae679444d3b8d25"` | no |
| <a name="input_dev_private_subnet_id"></a> [dev\_private\_subnet\_id](#input\_dev\_private\_subnet\_id) | Dev2 ENV Private Subnet ID | `string` | `"subnet-01b6c2037f4715ae5"` | no |
| <a name="input_dev_vpc_id"></a> [dev\_vpc\_id](#input\_dev\_vpc\_id) | Dev2 ENV VPC ID | `string` | `"vpc-0bd55d5f39a1e7810"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Cloudfront Alias Domain | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | `"dev"` | no |
| <a name="input_gha_codebuild_service_role_name"></a> [gha\_codebuild\_service\_role\_name](#input\_gha\_codebuild\_service\_role\_name) | CodeBuild Service Role | `string` | `"GHA-CodeBuild-Service-Role"` | no |
| <a name="input_kfd_api_lambda_name"></a> [kfd\_api\_lambda\_name](#input\_kfd\_api\_lambda\_name) | Name of the KFD API Lambda function | `string` | `"kainoscore-kfd-api"` | no |
| <a name="input_kms_cw_alias"></a> [kms\_cw\_alias](#input\_kms\_cw\_alias) | KMS Key Alias for cloudwatch | `string` | `"alias/kainoscore-cw-kms"` | no |
| <a name="input_kms_s3_alias"></a> [kms\_s3\_alias](#input\_kms\_s3\_alias) | KMS Key Alias for s3 | `string` | `"alias/kainoscore-s3-kms"` | no |
| <a name="input_kms_sns_topic_alias"></a> [kms\_sns\_topic\_alias](#input\_kms\_sns\_topic\_alias) | KMS Key Alias for SNS topic | `string` | `"alias/sns-topic-kms"` | no |
| <a name="input_lambda_memory"></a> [lambda\_memory](#input\_lambda\_memory) | Lambda Memory Size | `string` | `"512"` | no |
| <a name="input_lambda_role_name"></a> [lambda\_role\_name](#input\_lambda\_role\_name) | Role Name for Lambdas | `string` | `"kainoscore-Lambda-Role"` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda Runtime | `string` | `"nodejs22.x"` | no |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | Number of days to retain logs | `number` | `365` | no |
| <a name="input_provider_assume_role"></a> [provider\_assume\_role](#input\_provider\_assume\_role) | Whether the provider should assume Codebuild Deployment role | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |
| <a name="input_session_secret"></a> [session\_secret](#input\_session\_secret) | Session secret for the application | `string` | n/a | yes |
| <a name="input_waf_acl_name"></a> [waf\_acl\_name](#input\_waf\_acl\_name) | WAF ACL Name | `string` | `"cloudfront-waf-acl"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_access_control_id"></a> [cloudfront\_access\_control\_id](#output\_cloudfront\_access\_control\_id) | n/a |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | n/a |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | n/a |
| <a name="output_cloudfront_s3_cache_policy_id"></a> [cloudfront\_s3\_cache\_policy\_id](#output\_cloudfront\_s3\_cache\_policy\_id) | n/a |
| <a name="output_core_api_gateway_id"></a> [core\_api\_gateway\_id](#output\_core\_api\_gateway\_id) | Outputs the API Gateway ID |
| <a name="output_core_api_gateway_root_resource_id"></a> [core\_api\_gateway\_root\_resource\_id](#output\_core\_api\_gateway\_root\_resource\_id) | Outputs the root resource ID of the API Gateway |
| <a name="output_kfd_api_gateway_id"></a> [kfd\_api\_gateway\_id](#output\_kfd\_api\_gateway\_id) | n/a |
| <a name="output_kfd_api_gateway_id_regional"></a> [kfd\_api\_gateway\_id\_regional](#output\_kfd\_api\_gateway\_id\_regional) | n/a |
| <a name="output_kfd_api_gateway_root_resource_id"></a> [kfd\_api\_gateway\_root\_resource\_id](#output\_kfd\_api\_gateway\_root\_resource\_id) | n/a |
| <a name="output_kfd_api_gateway_root_resource_id_regional"></a> [kfd\_api\_gateway\_root\_resource\_id\_regional](#output\_kfd\_api\_gateway\_root\_resource\_id\_regional) | n/a |
| <a name="output_lambda_execution_role_arn"></a> [lambda\_execution\_role\_arn](#output\_lambda\_execution\_role\_arn) | n/a |
<!-- END_TF_DOCS -->