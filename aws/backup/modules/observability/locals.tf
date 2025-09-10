locals {
  base_lambda_widgets = [
    {
      type   = "metric"
      x      = 0
      y      = 0
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
        ]
        title  = "Execution Time (ms)"
        region = var.region
        stat   = "Average"
        annotations = {
          horizontal = [
            { color = "#ff9900", label = "Warning", value = 2000 },
            { color = "#d13212", label = "Critical", value = 3000 }
          ]
        }
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 6
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
        ]
        title  = "Execution Failures (Error Count)"
        region = var.region
        stat   = "Sum"
        annotations = {
          horizontal = [
            { color = "#d13212", label = "Any Error", value = 1 }
          ]
        }
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 12
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name],
          ["AWS/Lambda", "Throttles", "FunctionName", var.lambda_function_name]
        ]
        title  = "Load vs Throttled - Total Calls / Rejected"
        region = var.region
        stat   = "Sum"
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 18
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/Lambda", "ConcurrentExecutions", "FunctionName", var.lambda_function_name],
          ["AWS/Lambda", "IteratorAge", "FunctionName", var.lambda_function_name]
        ]
        title  = "Concurrency & Streaming Lag"
        region = var.region
        stat   = "Average"
      }
    }
  ]

  base_ecs_widgets = [
    {
      type   = "metric"
      x      = 0
      y      = 0
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name],
          ["AWS/ECS", "MemoryUtilization", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name]
        ]
        title  = "CPU & Memory Utilization (%)"
        region = var.region
        stat   = "Average"
        annotations = {
          horizontal = [
            { color = "#ff9900", label = "High", value = 70 },
            { color = "#d13212", label = "Critical", value = 90 }
          ]
        }
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 6
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["ECS/ContainerInsights", "NetworkTxBytes", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name, { "label" : "DataSent" }],
          ["ECS/ContainerInsights", "NetworkRxBytes", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name, { "label" : "DataReceived" }]
        ]
        title  = "Network I/O - Sent vs Received"
        region = var.region
        stat   = "Sum"
      }
    },
    {
      type   = "metric"
      x      = 0
      y      = 12
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name],
          ["ECS/ContainerInsights", "PendingTaskCount", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name],
          ["ECS/ContainerInsights", "DesiredTaskCount", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name]
        ]
        title  = "ECS Task States - Running / Pending / Desired"
        region = var.region
        stat   = "Average"
      }
    }
  ]


  log_widgets = [
    for idx, log_group in var.log_group_names : {
      type   = "metric"
      x      = 0
      y      = 18 + idx * 6
      width  = 12
      height = 6
      properties = {
        metrics = [
          ["Custom/Application", "WarnCount${replace(log_group, "/", "-")}", { "label" : "Warnings", "color" : "#ff9900" }],
          ["Custom/Application", "ErrorCount${replace(log_group, "/", "-")}", { "label" : "Errors", "color" : "#d13212" }]

        ]
        title   = "Application Log for: ${var.app_name}"
        region  = var.region
        stat    = "Sum"
        view    = "timeSeries"
        stacked = false
        period  = 300
        yAxis = {
          left = {
            min = 0
          }
        }
      }
    }
  ]

  lambda_widgets = concat(local.base_lambda_widgets, local.log_widgets)
  ecs_widgets    = concat(local.base_ecs_widgets, local.log_widgets)

}