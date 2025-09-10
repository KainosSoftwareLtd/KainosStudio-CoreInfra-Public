resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption used by CloudFront"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/kainoscore-s3-kms"
  target_key_id = aws_kms_key.s3_key.key_id
}


resource "aws_kms_key_policy" "s3_key_policy" {
  key_id = aws_kms_key.s3_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "KeyPolicy",
    Statement = [
      # Allow account administrators full access
      {
        Sid    = "EnableIAMUserPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "EnableSysAdminDecrypt",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_AWSAdministratorAccess_1a26381ad3e03eea"
        },
        Action   = "kms:Decrypt",
        Resource = "*"
      },
      # Allow CloudFront to decrypt objects
      {
        Sid    = "AllowCloudFrontDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Allow Codebuild to use the key 
      {
        Sid    = "AllowCodeBuildEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Allow API Gateway to decrypt objects
      {
        Sid    = "AllowAPIGatewayEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",

        ],
        Resource = "*"
      },

      # Allow Cloudwatch to use the key 

      {
        Sid    = "AllowAPIGatewayEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "logs.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },



      # Allow s3 to use the key 
      {
        Sid    = "Allows3Access",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },

      # Allow Lambda to use the key 
      {
        Sid    = "AllowLambdaAccess",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Allow S3 Log Delivery group to use the key
      {
        Sid    = "AllowS3LogDeliveryGroupAccess",
        Effect = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "cw_key" {
  description = "Kainoscore KMS Key for cloudwatch and other general encryption"
  # This key is used for encrypting CloudWatch logs and other resources like dynamodb
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "cw_key_alias" {
  name          = "alias/kainoscore-cw-kms"
  target_key_id = aws_kms_key.cw_key.key_id
}

resource "aws_kms_key_policy" "cw_key_policy" {
  key_id = aws_kms_key.cw_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "CWKeyPolicy",
    Statement = [
      # Allow account administrators full access
      {
        Sid    = "EnableIAMUserPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },

      # Allow API Gateway to decrypt objects
      {
        Sid    = "AllowAPIGatewayEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },

      # Allow Cloudwatch to use the key 

      {
        Sid    = "AllowCloudwatchEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "logs.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },

      # Allow Lambda to use the key 
      {
        Sid    = "AllowCloudFrontDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Add DynamoDB permissions
      {
        Sid    = "AllowDynamoDBEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "dynamodb.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Allow WAF to use the key for CloudWatch Logs encryption
      {
        Sid    = "AllowWAFEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      }
    ]
  })
}



#========


resource "aws_kms_key" "sns_alerts_key" {
  description             = "KMS key for SNS Topics encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "sns_alerts_alias" {
  name          = "alias/sns-topic-kms"
  target_key_id = aws_kms_key.sns_alerts_key.key_id
}

resource "aws_kms_key_policy" "sns_alerts_key_policy" {
  key_id = aws_kms_key.sns_alerts_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "SNSKeyPolicy",
    Statement = [
      # Allow account administrators full access
      {
        Sid    = "EnableIAMUserPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },

      # Allow CloudWatch to encrypt messages
      {
        Sid    = "AllowCloudWatchToUseKMS",
        Effect = "Allow",
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },

      # Allow SNS to use the key 

      {
        Sid    = "AllowSNSToUseKMS",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      }
    ]
  })
}

# KMS key for WAF CloudWatch logs (must be in us-east-1)
resource "aws_kms_key" "waf_logs_key" {
  provider                = aws.useast1
  description             = "KMS key for WAF CloudWatch logs encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "waf_logs_key_alias" {
  provider      = aws.useast1
  name          = "alias/kainoscore-waf-logs-kms"
  target_key_id = aws_kms_key.waf_logs_key.key_id
}

resource "aws_kms_key_policy" "waf_logs_key_policy" {
  provider = aws.useast1
  key_id   = aws_kms_key.waf_logs_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "WAFLogsKeyPolicy",
    Statement = [
      # Allow account administrators full access
      {
        Sid    = "EnableIAMUserPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      # Allow CloudWatch Logs to use the key
      {
        Sid    = "AllowCloudWatchLogsEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "logs.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      },
      # Allow WAF log delivery service to use the key
      {
        Sid    = "AllowWAFLogDeliveryEncryptDecrypt",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
        ],
        Resource = "*"
      }
    ]
  })
}
