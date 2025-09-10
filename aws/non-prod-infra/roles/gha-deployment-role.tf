# CodeBuild Role
resource "aws_iam_role" "codebuild_service_role" {
  name               = "GHA-CodeBuild-Service-Role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    sid     = "AllowCodeBuildAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
  statement {
    sid     = "AllowFEDERATEDROLEUSER"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:sts::975050265283:assumed-role/AWSReservedSSO_AWSAdministratorAccess_595eb2c361766093/erastus.ndi@kainos.com",
      "arn:aws:sts::975050265283:assumed-role/AWSReservedSSO_AWSAdministratorAccess_595eb2c361766093/konrada@kainos.com"]
    }
  }


  statement {
    sid    = "AllowGitHubActions"
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::975050265283:oidc-provider/token.actions.githubusercontent.com"]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:KainosSoftwareLtd/KainosStudio-CoreInfra:pull_request",
        "repo:KainosSoftwareLtd/KainosStudio-CoreInfra:ref:refs/heads/main",
        "repo:KainosSoftwareLtd/KainosStudio-CoreApp:pull_request",
        "repo:KainosSoftwareLtd/KainosStudio-CoreApp:ref:refs/heads/main",
        "repo:KainosSoftwareLtd/KainosStudio-CoreInfra:environment:Dev",
        "repo:KainosSoftwareLtd/KainosStudio-CoreInfra:environment:Pipeline",
        "repo:KainosSoftwareLtd/KainosStudio-CoreInfra:environment:Staging",
        "repo:KainosSoftwareLtd/KainosStudio-CoreApp:environment:Dev",
        "repo:KainosSoftwareLtd/KainosStudio-CoreApp:environment:Staging",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "codebuild_service_policy" {
  name   = "GHA-CodeBuildServicePolicy-KC"
  policy = data.aws_iam_policy_document.codebuild_service_policy.json
}

resource "aws_iam_policy" "codebuild_service_policy1" {
  name   = "GHA-CodeBuildServicePolicy-KC1"
  policy = data.aws_iam_policy_document.codebuild_service_policy1.json
}

resource "aws_iam_policy" "codebuild_service_policy2" {
  name   = "GHA-CodeBuildServicePolicy-KC2"
  policy = data.aws_iam_policy_document.codebuild_service_policy2.json

}
resource "aws_iam_policy" "codebuild_service_policy3" {
  name   = "GHA-CodeBuildServicePolicy-KC3"
  policy = data.aws_iam_policy_document.codebuild_service_policy3.json

}
data "aws_iam_policy_document" "codebuild_service_policy2" {

  # Network Full Access
  statement {
    sid    = "VPCManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:ModifySubnetAttribute",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",
      "ec2:ModifyNatGatewayAttributes",
      "ec2:CreateVpcPeeringConnection",
      "ec2:DeleteVpcPeeringConnection",
      "ec2:AcceptVpcPeeringConnection",
      "ec2:RejectVpcPeeringConnection",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteVpcEndpoint",
      "ec2:ModifyVpcEndpoint",
      "ec2:ModifyVpcEndpointServiceConfiguration"
    ]
    resources = [
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:vpc/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:route-table/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:internet-gateway/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:natgateway/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:vpc-peering-connection/*",
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:vpc-endpoint/*",
    ]
  }

  statement {
    sid    = "DescribeVpcAttribute"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcAttribute",
    ]
    resources = [
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:vpc/*"
    ]
  }

  statement {
    sid    = "SecurityGroupManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",

    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:security-group/*"]
  }

  statement {
    sid    = "ENIManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:RevokeNetworkInterfacePermission"
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:network-interface/*"]
  }

  statement {
    sid    = "EC2InstanceManagement"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyInstancePlacement",
      "ec2:ModifyInstanceCapacityReservationAttributes",
      "ec2:MonitorInstances",
      "ec2:UnmonitorInstances",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:ModifyNetworkInterfaceAttribute",
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/*"]
  }

  statement {
    sid    = "ElasticIPManagement"
    effect = "Allow"
    actions = [
      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:elastic-ip/*"]
  }

  statement {
    sid    = "NetworkACLManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkAcl",
      "ec2:DeleteNetworkAcl",
      "ec2:CreateNetworkAclEntry",
      "ec2:DeleteNetworkAclEntry",
      "ec2:ReplaceNetworkAclEntry",
      "ec2:ReplaceNetworkAclAssociation",
    ]
    resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:network-acl/*"]
  }

  statement {
    sid    = "EC2DescribeOperations"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNatGateways",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribePrefixLists",
      "ec2:DescribeAddressesAttribute"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid       = "EC2PassRolePermission"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }

  # Codestar Connections
  statement {
    sid    = "CodeStarConnection"
    effect = "Allow"
    actions = [

      "codestar-connections:CreateConnection",
      "codestar-connections:DeleteConnection",
      "codestar-connections:GetConnection",
      "codestar-connections:ListConnections",
      "codestar-connections:GetInstallationUrl",
      "codestar-connections:GetIndividualAccessToken",
      "codestar-connections:ListInstallationTargets",
      "codestar-connections:StartOAuthHandshake",
      "codestar-connections:UpdateConnectionInstallation",
      "codestar-connections:UseConnection",
      "codestar-connections:TagResource",
      "codestar-connections:ListTagsForResource",
      "codestar-connections:UntagResource"
    ]
    resources = ["${data.aws_codestarconnections_connection.kainosstudio.arn}"]
  }


  # Parameter Store
  statement {
    sid    = "SSMParameterStoreAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DescribeParameters",
      "ssm:ListTagsForResource",
      "ssm:GetParameters",
      "ssm:DeleteParameter"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/*",
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    sid    = "MonitoringPermissions"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetDashboard",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:DeleteAlarms"

    ]
    resources = ["arn:aws:cloudwatch:${var.region}:${data.aws_caller_identity.current.account_id}:*",
      "arn:aws:cloudwatch::${data.aws_caller_identity.current.account_id}:dashboard/*",
    ]
  }

  statement {
    sid    = "S3KMSKeyAccess"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GetKeyRotationStatus"
    ]
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*",
      "arn:aws:kms:us-east-1:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

}
data "aws_iam_policy_document" "codebuild_service_policy3" {
  statement {
    sid    = "DynamoDBTableAccess"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/terraform-kainoscore-lock",
    ]
  }

  statement {
    sid    = "CoreFormSessionsTableManagement"
    effect = "Allow"
    actions = [
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable",
      "dynamodb:UpdateTable",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
      "dynamodb:UpdateTimeToLive",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:UpdateContinuousBackups",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:ListTagsOfResource",
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/Core_FormSessions_*"
    ]
  }
}
# tfsec:ignore aws-iam-no-policy-wildcards Justification: Added condition to match tag "ServiceName" = "kainoscore". This is required to create APIs.
data "aws_iam_policy_document" "codebuild_service_policy1" {

  statement {
    sid    = "IAMReadAccessForCodeBuild"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:ListRoles",
      "iam:GetRole",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:UpdatePolicy",
      "iam:ListPolicies",
      "iam:GetPolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PassRole",
      "iam:TagPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:TagRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:CreatePolicyVersion"

    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*"
    ]
  }



  # Lambda Management Permissions
  statement {
    sid    = "LambdaManagementPermissions"
    effect = "Allow"
    actions = [
      # Lambda Function Management
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:GetFunction",
      "lambda:ListFunctions",
      "lambda:PublishVersion",
      "lambda:CreateAlias",
      "lambda:DeleteAlias",
      "lambda:UpdateAlias",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:ListEventSourceMappings",
      "lambda:CreateEventSourceMapping",
      "lambda:DeleteEventSourceMapping",
      "lambda:TagResource",
      "lambda:ListVersionsByFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetFunctionConfiguration",
      "lambda:GetAlias",
      "lambda:ListAliases",
      "lambda:InvokeAlias",
      "lambda:UntagResource",
      "lambda:ListTags",
      "lambda:GetPolicy",
      # (Optional) Lambda Layers Management
      "lambda:PublishLayerVersion",
      "lambda:DeleteLayerVersion",
      "lambda:GetLayerVersion",
      "lambda:ListLayers",
      "lambda:ListLayerVersions",
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:kainoscore-*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/ServiceName"
      values   = ["kainoscore"]
    }
  }
  # API Gateway Permissions with Tag-Based Condition
  statement {
    sid    = "APIGatewayPermissions"
    effect = "Allow"
    actions = [
      "apigateway:CreateRestApi",
      "apigateway:DeleteRestApi",
      "apigateway:UpdateRestApi",
      "apigateway:GetRestApi",
      "apigateway:ListRestApis",
      "apigateway:CreateResource",
      "apigateway:DeleteResource",
      "apigateway:UpdateResource",
      "apigateway:GetResource",
      "apigateway:ListResources",
      "apigateway:CreateMethod",
      "apigateway:DeleteMethod",
      "apigateway:UpdateMethod",
      "apigateway:GetMethod",
      "apigateway:PutIntegration",
      "apigateway:DeleteIntegration",
      "apigateway:GetIntegration",
      "apigateway:PutMethodResponse",
      "apigateway:DeleteMethodResponse",
      "apigateway:GetMethodResponse",
      "apigateway:CreateDeployment",
      "apigateway:DeleteDeployment",
      "apigateway:UpdateDeployment",
      "apigateway:GetDeployment",
      "apigateway:ListDeployments",
      "apigateway:CreateStage",
      "apigateway:DeleteStage",
      "apigateway:UpdateStage",
      "apigateway:GetStage",
      "apigateway:ListStages",
      "apigateway:CreateAuthorizer",
      "apigateway:DeleteAuthorizer",
      "apigateway:UpdateAuthorizer",
      "apigateway:GetAuthorizer",
      "apigateway:ListAuthorizers",
      "apigateway:CreateModel",
      "apigateway:DeleteModel",
      "apigateway:UpdateModel",
      "apigateway:GetModel",
      "apigateway:ListModels",
      "apigateway:TagResource",
      "apigateway:UntagResource",
      "apigateway:UpdateRestApiPolicy",
      "apigateway:PUT",
      "apigateway:POST",
      "apigateway:GET",
      "apigateway:PATCH",
      "apigateway:DELETE"
    ]

    resources = [
      "arn:aws:apigateway:${var.region}::/restapis/*",
      "arn:aws:apigateway:${var.region}::/restapis",
      "arn:aws:apigateway:${var.region}::/tags/*",
      "arn:aws:apigateway:${var.region}::/account",
      "arn:aws:apigateway:${var.region}::/tags/*/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/ServiceName"
      values   = ["kainoscore"]
    }
  }


  # KMS Key
  statement {
    sid    = "KMSKeyManagement"
    effect = "Allow"
    actions = [
      # KMS Key Management
      "kms:CreateKey",
      "kms:DeleteKey",
      "kms:EnableKey",
      "kms:DisableKey",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:DescribeKey",
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:UpdateAlias",
      "kms:PutKeyPolicy",
      "kms:GetKeyPolicy",
      "kms:ListKeyPolicies",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:GenerateDataKey",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:UpdateKeyDescription",

    ]
    resources = [
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*",
      "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:alias/kainoscore-*",
      "arn:aws:kms:us-east-1:${data.aws_caller_identity.current.account_id}:key/*",
      "arn:aws:kms:us-east-1:${data.aws_caller_identity.current.account_id}:alias/*"


    ]
  }

  # API Gateway Patch
  statement {
    sid    = "APIGatewayPatch"
    effect = "Allow"
    actions = [
      "apigateway:PATCH",
      "apigateway:GET"
    ]
    resources = [
      "arn:aws:apigateway:${var.region}::/account"
    ]
  }



  # Terraform S3 Bucket Access with Prefix Restriction
  statement {
    sid    = "TerraformS3BucketCreation"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:DeleteBucketWebsite",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:GetBucketAcl",
      "s3:GetBucketCors",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketPolicy",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetReplicationConfiguration",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts",
      "s3:PutBucketAcl",
      "s3:PutBucketCors",
      "s3:PutBucketLogging",
      "s3:PutBucketNotification",
      "s3:PutBucketPolicy",
      "s3:PutBucketRequestPayment",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketWebsite",
      "s3:PutEncryptionConfiguration",
      "s3:PutInventoryConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutBucketObjectLockConfiguration",
      "s3:BypassGovernanceRetention",
      "s3:PutReplicationConfiguration",
      "s3:RestoreObject",
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
      "s3:Tagging",
      "s3:UntagObject",
      "s3:UntagObjectVersion",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketOwnershipControls",
      "s3:GetBucketOwnershipControls"
    ]
    resources = [
      "arn:aws:s3:::kainoscore-*",
      "arn:aws:s3:::kainoscore-*/*"
    ]
  }


  # Terraform S3 Bucket Access
  statement {
    sid    = "TerraformS3BucketObjectManagement"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:CreateBucket",
      "s3:GetBucketTagging"
    ]


    resources = ["arn:aws:s3:::*"]
  }



}



data "aws_iam_policy_document" "codebuild_service_policy" {


  statement {
    sid    = "APIGatewayNestedTaggingPermissions"
    effect = "Allow"
    actions = [
      "apigateway:TagResource",
      "apigateway:UntagResource"
    ]
    resources = [
      "arn:aws:apigateway:${var.region}::/tags/*/*"
    ]
  }

  # ECR Permissions for CodeBuild to Push Docker Images
  statement {
    sid    = "ECRPermissions"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutRegistryScanningConfiguration",
      "ecr:DescribeRegistry",
      "ecr:GetRegistryScanningConfiguration",
      "ecr:ListTagsForResource"

    ]
    resources = [
      "*"
    ]
  }

  # KMS Key List Aliases
  statement {
    sid    = "KMSKeyListAliases"
    effect = "Allow"
    actions = [

      "kms:ListAliases"

    ]
    resources = [
      "*",

    ]
  }

  # WAFv2 Permissions
  statement {
    sid    = "WAFv2Permissions"
    effect = "Allow"
    actions = [
      "wafv2:CreateWebACL",
      "wafv2:UpdateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:GetWebACL",
      "wafv2:ListWebACLs",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "wafv2:CreateRuleGroup",
      "wafv2:UpdateRuleGroup",
      "wafv2:DeleteRuleGroup",
      "wafv2:GetRuleGroup",
      "wafv2:ListRuleGroups",
      "wafv2:CreateIPSet",
      "wafv2:UpdateIPSet",
      "wafv2:DeleteIPSet",
      "wafv2:GetIPSet",
      "wafv2:ListIPSets",
      "wafv2:CreateRegexPatternSet",
      "wafv2:UpdateRegexPatternSet",
      "wafv2:DeleteRegexPatternSet",
      "wafv2:GetRegexPatternSet",
      "wafv2:ListRegexPatternSets",
      "wafv2:TagResource",
      "wafv2:ListTagsForResource",
      "wafv2:GetLoggingConfiguration"
    ]
    resources = [
      "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:regional/webacl/*",
      "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:regional/rulegroup/*",
      "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:global/managedruleset/*/*",
      "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:global/webacl/*",
      "arn:aws:wafv2:${var.region}:${data.aws_caller_identity.current.account_id}:regional/rulegroup/*",
      "arn:aws:wafv2:${var.region}:${data.aws_caller_identity.current.account_id}:global/managedruleset/*/*",
    ]
  }

  # Parameter Store Access
  statement {
    sid    = "SSMParameterStoreAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DescribeParameters",
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/kc/*",
    ]
  }

  # CloudWatch Logs Access
  statement {
    sid     = "CloudWatchLogsAccess"
    effect  = "Allow"
    actions = ["logs:*"]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/apigateway/*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group::log-stream:*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*",
      "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/wafv2/*",
      "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:*"
    ]
  }

  # CodeBuild Report Group Permissions
  statement {
    sid    = "CodeBuildReportGroupPermissions"
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:UpdateReportGroup",
      "codebuild:DeleteReportGroup",
      "codebuild:DescribeReportGroups",
      "codebuild:ListReportGroups",
    ]
    resources = [
      "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:report-group/*",
    ]
  }

  statement {
    sid    = "CodeBuildAccess"
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:BatchGetProjects",
      "codebuild:CreateProject",
      "codebuild:UpdateProject",
      "codebuild:ListProjects",
      "codebuild:DeleteProject",
      "codebuild:BatchGetReportGroups",
      "codebuild:BatchGetReports"
    ]
    resources = [
      "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/KainosCore-*",
      "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/Kainoscore-*"
    ]
  }

  # CloudFront Management
  statement {
    sid    = "CloudFrontManagementCreateAndDelete"
    effect = "Allow"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
      "cloudfront:ListDistributions",
      "cloudfront:CreateAlias",
      "cloudfront:DeleteAlias",
      "cloudfront:UpdateAlias",
      "cloudfront:ListEventSourceMappings",
      "cloudfront:CreateEventSourceMapping",
      "cloudfront:DeleteEventSourceMapping",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:CreateCachePolicy",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetCachePolicy",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:DeleteCachePolicy",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:ListTagsForResource",
      "cloudfront:CreateCachePolicy"


    ]
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*",
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:origin-access-control/*",
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:cache-policy/*",
    ]
  }
}

# Attach IAM Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_service_policy_attachment" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_service_policy.arn
}

# Attach IAM Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_service_policy_attachment1" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_service_policy1.arn
}

# Attach IAM Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_service_policy_attachment2" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_service_policy2.arn
}

# Attach IAM Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_service_policy_attachment3" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_service_policy3.arn
}