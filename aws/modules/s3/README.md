
## Description
```hcl
A versatile and reusable Terraform module for provisioning and managing AWS S3 buckets with advanced configurations. 
This module allows you to create S3 buckets tailored to your specific needs by enabling optional features such as 
versioning, server access logging, server-side encryption with AWS KMS, public access blocking, and automated file uploads. 
Whether you're setting up a simple storage solution or a complex, secure data repository, this module provides the flexibility and control required to streamline your infrastructure as code workflows.
```
## Basic Usage

```hcl
module "basic_s3_bucket" {
  source      = "../" # Adjust the path based on your directory structure
  bucket_name = "my-basic-bucket"
}
```
## Advanced Usage
 ```hcl
module "advanced_s3_bucket" {
  source = "../" # Adjust the path based on your directory structure

  bucket_name                = "my-advanced-bucket"
  tags                       = { Environment = "production", Owner = "DevOps" }
  enable_versioning          = true
  enable_logging             = true
  logging_target_bucket      = "my-log-bucket"
  logging_target_prefix      = "prod-advanced-logs/"
  environment                = "prod"
  enable_encryption          = true
  kms_key_id                 = data.aws_kms_key.s3_key.arn
  enable_public_access_block = true
  upload_files               = true
  files_path          = "./static-files/"
}

data "aws_kms_key" "s3_key" {
  alias = "alias/my-s3-key"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket. | `string` | n/a | yes |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable server-side encryption for the S3 bucket. | `bool` | `false` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable server access logging for the S3 bucket. | `bool` | `false` | no |
| <a name="input_enable_public_access_block"></a> [enable\_public\_access\_block](#input\_enable\_public\_access\_block) | Enable public access block for the S3 bucket. | `bool` | `false` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning for the S3 bucket. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name, used for logging prefix. | `string` | `"dev"` | no |
| <a name="input_files_path"></a> [files\_path](#input\_files\_path) | Local path to the static files to upload. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for server-side encryption. | `string` | `null` | no |
| <a name="input_logging_target_bucket"></a> [logging\_target\_bucket](#input\_logging\_target\_bucket) | The target bucket to store logs. | `string` | `null` | no |
| <a name="input_logging_target_prefix"></a> [logging\_target\_prefix](#input\_logging\_target\_prefix) | The prefix for log object keys. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the S3 bucket. | `map(string)` | `{}` | no |
| <a name="input_upload_files"></a> [upload\_files](#input\_upload\_files) | Enable uploading static files to the S3 bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The DNS name of the bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 bucket. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The regional DNS name of the bucket. |
| <a name="output_encryption_configuration"></a> [encryption\_configuration](#output\_encryption\_configuration) | Server-side encryption configuration of the bucket. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The hosted zone ID of the bucket. |
| <a name="output_logging_configuration"></a> [logging\_configuration](#output\_logging\_configuration) | Logging configuration of the bucket. |
| <a name="output_public_access_block"></a> [public\_access\_block](#output\_public\_access\_block) | Public access block configuration of the bucket. |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags assigned to the bucket. |
| <a name="output_versioning_status"></a> [versioning\_status](#output\_versioning\_status) | Versioning status of the bucket. |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | The website domain of the bucket. |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | The website endpoint of the bucket. |  
