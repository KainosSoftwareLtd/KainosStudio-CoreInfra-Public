## Description

The Lambda Terraform Module is a reusable and flexible module designed to simplify the deployment and management of AWS Lambda functions. It supports multiple deployment methods including local ZIP files, S3-hosted packages, and container images. The module allows you to configure essential settings such as function name, runtime, handler, memory size, and environment variables dynamically through input variables. The module also supports optional alias creation for version management and integrates with CloudWatch for logging with customizable retention and encryption settings. By leveraging this module, you can efficiently provision multiple Lambda functions across different environments (e.g., development, prod, production) with consistent configurations, enhancing scalability and maintainability in your infrastructure as code (IaC) workflows.

## Deployment Methods

This module supports three mutually exclusive deployment methods:

1. **Local Source Directory**: Automatically packages your source code into a ZIP file
2. **Pre-built ZIP File**: Uses an existing ZIP file 
3. **S3-hosted Package**: References a ZIP file stored in S3
4. **Container Image**: Uses a container image from ECR

## Basic Usage - Local Source Directory

```hcl
module "basic_lambda" {
  source = "../modules/lambda"

  function_name             = "basicLambda"
  description               = "A basic AWS Lambda function"
  env                       = "dev"
  handler                   = "index.handler"
  runtime                   = "nodejs18.x"
  memory_size               = 256
  environment_variables     = {
    NODE_ENV      = "development"
    LOG_LEVEL     = "info"
  }
  logs_retention_days       = 30
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "development"
    Project     = "BasicProject"
  }
  
  # Local source directory - will be packaged automatically
  lambda_source_dir = "lambdas/basic/"
  publish           = true
}
```

## Usage - Pre-built ZIP File

```hcl
module "prebuilt_lambda" {
  source = "../modules/lambda"

  function_name             = "prebuiltLambda"
  description               = "Lambda function using pre-built ZIP"
  env                       = "dev"
  handler                   = "index.handler"
  runtime                   = "nodejs18.x"
  memory_size               = 256
  environment_variables     = {
    NODE_ENV = "development"
  }
  logs_retention_days       = 30
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "development"
    Project     = "PrebuiltProject"
  }
  
  # Pre-built ZIP file
  filename = "path/to/lambda-package.zip"
  publish  = true
}
```

## Usage - S3-hosted Package

```hcl
module "s3_lambda" {
  source = "../modules/lambda"

  function_name             = "s3Lambda"
  description               = "Lambda function using S3-hosted package"
  env                       = "prod"
  handler                   = "index.handler"
  runtime                   = "nodejs18.x"
  memory_size               = 512
  environment_variables     = {
    NODE_ENV = "production"
    API_URL  = "https://api.example.com"
  }
  logs_retention_days       = 14
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "production"
    Project     = "S3Project"
  }
  
  # S3-hosted package
  s3_bucket         = "my-lambda-packages"
  s3_key            = "lambda-functions/my-function.zip"
  s3_object_version = "abc123def456"  # Optional
  publish           = true
}
```

## Usage - Container Image

```hcl
module "container_lambda" {
  source = "../modules/lambda"

  function_name             = "containerLambda"
  description               = "Lambda function using container image"
  env                       = "prod"
  memory_size               = 1024
  environment_variables     = {
    NODE_ENV = "production"
    LOG_LEVEL = "info"
  }
  logs_retention_days       = 14
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "production"
    Project     = "ContainerProject"
  }
  
  # Container image from ECR
  image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-lambda:latest"
  publish   = true
}
```

## Advanced Usage with Alias

```hcl
module "advanced_lambda" {
  source = "../modules/lambda"

  function_name             = "advancedLambda"
  description               = "An advanced AWS Lambda function with alias and extended configurations"
  env                       = "prod"
  handler                   = "app.handler"
  runtime                   = "python3.11"
  memory_size               = 512
  environment_variables     = {
    DATABASE_URL          = var.database_url
    API_KEY               = var.api_key
    FEATURE_FLAG_ENABLE_X = "true"
    LOG_LEVEL             = "debug"
    NODE_ENV              = "production"
  }
  logs_retention_days       = 14
  alias_name                = "stable"
  lambda_execution_role_arn = aws_iam_role.lambda_exec.arn
  cloudwatch_kms_key_id     = aws_kms_key.cloudwatch_logs.arn
  tags = {
    Environment = "production"
    Project     = "AdvancedProject"
    Owner       = "DevOpsTeam"
    Compliance  = "PCI-DSS"
  }
  
  # S3 source for CI/CD deployments
  s3_bucket = "my-cicd-artifacts"
  s3_key    = "lambda-packages/advanced-function.zip"
  publish   = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias_name"></a> [alias\_name](#input\_alias\_name) | Alias name for the Lambda function (optional) | `string` | `null` | no |
| <a name="input_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#input\_cloudwatch\_kms\_key\_id) | KMS key ID for CloudWatch log group encryption | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment name (e.g., dev, prod) | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables for the Lambda function | `map(string)` | n/a | yes |
| <a name="input_filename"></a> [filename](#input\_filename) | Local ZIP path for deployment. Conflicts with image_uri and s3_bucket+s3_key. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Handler for the Lambda function (e.g., index.handler) | `string` | n/a | yes |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI. Conflicts with filename and S3 sources. | `string` | `null` | no |
| <a name="input_lambda_execution_role_arn"></a> [lambda\_execution\_role\_arn](#input\_lambda\_execution\_role\_arn) | ARN of the IAM role for Lambda execution | `string` | n/a | yes |
| <a name="input_lambda_source_dir"></a> [lambda\_source\_dir](#input\_lambda\_source\_dir) | Directory containing Lambda source code (only used for ZIP archives) | `string` | `null` | no |
| <a name="input_logs_retention_days"></a> [logs\_retention\_days](#input\_logs\_retention\_days) | Number of days to retain logs in CloudWatch | `number` | n/a | yes |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size for the Lambda function (in MB) | `number` | n/a | yes |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish a new version of the Lambda function | `bool` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime environment for the Lambda function (e.g., nodejs18.x). Not required for container images. | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket for ZIP deployment. Requires s3_key. | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 key of the deployment package. | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | (Optional) version of the S3 object. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_alias_arn"></a> [lambda\_alias\_arn](#output\_lambda\_alias\_arn) | ARN of the Lambda alias |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | ARN of the Lambda function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Name of the Lambda function |
| <a name="output_lambda_version"></a> [lambda\_version](#output\_lambda\_version) | Version of the Lambda function |

## Important Notes

- **Mutually Exclusive Sources**: You must specify exactly one of: `filename`, `image_uri`, or (`s3_bucket` + `s3_key`). The module will validate this automatically.
- **Runtime**: Not required when using container images (`image_uri`).
- **Handler**: Not required when using container images, but still required for ZIP-based deployments.
- **Source Code Management**: When using S3 or container deployments with CI/CD, the module uses `ignore_changes` lifecycle rules to prevent Terraform from overriding CI/CD deployments.
- **Lambda Source Directory**: Only used when creating local ZIP archives. Ignored for other deployment methods.