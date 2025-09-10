resource "aws_cloudwatch_log_metric_filter" "error_filters" {
  for_each = toset(var.log_group_names)

  name           = "error-count${replace(each.key, "/", "-")}"
  log_group_name = each.key
  pattern        = "{ $.level = \"error\" }"

  metric_transformation {
    name      = "ErrorCount${replace(each.key, "/", "-")}"
    namespace = "Custom/Application"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "warn_filters" {
  for_each = toset(var.log_group_names)

  name           = "warn-count${replace(each.key, "/", "-")}"
  log_group_name = each.key
  pattern        = "{ $.level = \"warn\" }"

  metric_transformation {
    name      = "WarnCount${replace(each.key, "/", "-")}"
    namespace = "Custom/Application"
    value     = "1"
  }
}

resource "aws_cloudwatch_dashboard" "lambda_dashboard" {
  count          = var.app_name == "coreapp" ? 1 : 0
  dashboard_name = "${var.environment}-${var.app_name}"
  dashboard_body = jsonencode({
    widgets = local.lambda_widgets
  })
}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  count          = var.app_name == "servicebuilder" ? 1 : 0
  dashboard_name = "${var.environment}-${var.app_name}"
  dashboard_body = jsonencode({
    widgets = local.ecs_widgets
  })
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count               = var.app_name == "coreapp" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-lambda-errors"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Sum"
  period              = 60
  alarm_description   = "Lambda function has errors"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  count               = var.app_name == "coreapp" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-lambda-duration"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 3000
  statistic           = "Average"
  period              = 60
  alarm_description   = "Lambda execution time is too high"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  count               = var.app_name == "coreapp" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-lambda-throttles"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Sum"
  period              = 60
  alarm_description   = "Lambda is being throttled"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  count               = var.app_name == "servicebuilder" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-ecs-cpu-utilization"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 85
  statistic           = "Average"
  period              = 60
  alarm_description   = "ECS CPU usage is too high"
  dimensions = {
    ServiceName = var.ecs_service_name
    ClusterName = var.ecs_cluster_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  count               = var.app_name == "servicebuilder" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-ecs-memory-utilization"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 85
  statistic           = "Average"
  period              = 60
  alarm_description   = "ECS Memory usage is too high"
  dimensions = {
    ServiceName = var.ecs_service_name
    ClusterName = var.ecs_cluster_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_pending_tasks" {
  count               = var.app_name == "servicebuilder" && var.enable_alarms ? 1 : 0
  alarm_name          = "${var.environment}-ecs-pending-tasks"
  metric_name         = "PendingTaskCount"
  namespace           = "ECS/ContainerInsights"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 0
  statistic           = "Average"
  period              = 60
  alarm_description   = "ECS has pending tasks"
  dimensions = {
    ServiceName = var.ecs_service_name
    ClusterName = var.ecs_cluster_name
  }
  alarm_actions = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "log_error_count" {
  for_each = var.enable_alarms ? { for lg in var.log_group_names : lg => lg } : {}

  alarm_name          = "${var.environment}-error-count${replace(each.key, "/", "-")}"
  metric_name         = "ErrorCount${replace(each.key, "/", "-")}"
  namespace           = "Custom/Application"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Sum"
  period              = 60
  alarm_description   = "Error log count exceeded in ${each.key}"
  alarm_actions       = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "log_warn_count" {
  for_each = var.enable_alarms ? { for lg in var.log_group_names : lg => lg } : {}

  alarm_name          = "${var.environment}-warn-count${replace(each.key, "/", "-")}"
  metric_name         = "WarnCount${replace(each.key, "/", "-")}"
  namespace           = "Custom/Application"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Sum"
  period              = 60
  alarm_description   = "Warning log count exceeded in ${each.key}"
  alarm_actions       = var.external_sns_topic_arn != "" ? [var.external_sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

resource "aws_sns_topic" "alerts" {
  count             = var.external_sns_topic_arn == "" ? 1 : 0
  name              = "${var.environment}-alerts-topic"
  kms_master_key_id = var.sns_kms_id
}

resource "aws_iam_role" "lambda_alerts_role" {
  count = var.external_sns_topic_arn == "" ? 1 : 0
  name  = "${var.environment}-alerts-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_alerts_basic_execution" {
  count      = var.external_sns_topic_arn == "" ? 1 : 0
  role       = aws_iam_role.lambda_alerts_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_alerts" {
  count = var.external_sns_topic_arn == "" ? 1 : 0
  # checkov:skip=CKV_AWS_115 - Concurrency limit is not required for a scheduled Lambda job
  # checkov:skip=CKV_AWS_116 - DLQ is not required for a cron job Lambda
  # checkov:skip=CKV_AWS_117 - Lambda manages resources across multiple VPCs and should not be inside a VPC
  # checkov:skip=CKV_AWS_173 - No sensitive environment variables stored in Lambda
  # checkov:skip=CKV_AWS_272 - Code Signing is not required as deployment is controlled via Terraform and CI/CD
  # checkov:skip=CKV_AWS_355 - Some permissions required '*'
  # checkov:skip=CKV_AWS_50  - X-Ray tracing not required for this lambda"
  function_name    = "${var.environment}-alerts-lambda"
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_alerts_role[0].arn
  filename         = data.archive_file.lambda_alerts_zip.output_path
  source_code_hash = data.archive_file.lambda_alerts_zip.output_base64sha256
  timeout          = 30
  environment {
    variables = {
      TEAMS_WEBHOOK_URL = var.teams_webhook_url
      ENVIRONMENT       = var.environment
    }
  }
}

resource "aws_lambda_permission" "allow_sns" {
  count         = var.external_sns_topic_arn == "" ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_alerts[0].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts[0].arn
}

resource "aws_sns_topic_subscription" "lambda_sub" {
  count     = var.external_sns_topic_arn == "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_alerts[0].arn
}