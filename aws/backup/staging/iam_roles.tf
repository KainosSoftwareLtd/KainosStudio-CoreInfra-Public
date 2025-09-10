# Policy document for the Lambda execution role
data "aws_iam_policy_document" "lambda_execution_role_policy" {

  statement {
    sid    = "LambdaCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${module.core_lambda.lambda_function_name}:*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${module.kfd_api_lambda.lambda_function_name}:*"
    ]
  }

  statement {
    sid    = "LambdaS3ReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutBucketNotification",
      "s3:GetBucketNotification"
    ]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_kfd_name}/*",
      "arn:aws:s3:::${local.s3_bucket_static_files_name}/*",
      "arn:aws:s3:::${local.s3_bucket_submitted_form_data_name}/*"
    ]
  }

  statement {
    sid    = "LambdaS3DeleteObject"
    effect = "Allow"
    actions = [
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_kfd_name}/*"
    ]
  }

  statement {
    sid    = "LambdaS3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_kfd_name}"
    ]
  }

  statement {
    sid    = "LambdaKMSUsage"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [
      data.aws_kms_alias.s3.target_key_arn,
      data.aws_kms_alias.cw.target_key_arn
    ]
  }

  statement {
    sid    = "LambdaDynamoDBAccess"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.core_form_sessions.arn
    ]
  }

}


# IAM role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.lambda_role_name}${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.tags
}

# IAM policy for Lambda execution
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_role_name}${var.env}-policy"
  description = "Policy for lambda execution role"
  policy      = data.aws_iam_policy_document.lambda_execution_role_policy.json
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Outputs

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
