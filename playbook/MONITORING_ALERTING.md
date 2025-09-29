# Monitoring and Alerting Guide

This guide documents the current monitoring and logging setup for the Kainos Studio Core Infrastructure across AWS and Azure environments.

## 📊 Overview

The Kainos Studio infrastructure implements comprehensive monitoring and alerting across application performance, infrastructure health, security events, and business metrics.

## 🟠 AWS Monitoring Setup

### CloudWatch Logs

| Log Group | Purpose | Retention | Environment |
|-----------|---------|-----------|-------------|
| `/aws/lambda/kainos-core-dev` | Development function logs | 7 days | Development |
| `/aws/lambda/kainos-core-staging` | Staging function logs | 30 days | Staging |
| `/aws/lambda/kainos-core-prod` | Production function logs | 90 days | Production |
| `/aws/lambda/kainos-upload-prod` | Upload function logs | 90 days | Production |

#### Log Configuration
```hcl
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.cloudwatch_kms_key_id
  
  tags = {
    Environment = var.environment
    Service     = "kainos-core"
  }
}
```

### CloudWatch Metrics

#### Application Metrics
| Metric | Description | Threshold | Alert Action |
|--------|-------------|-----------|--------------|
| **Duration** | Function execution time | > 25 seconds | SNS notification |
| **Errors** | Function error count | > 5 in 5 minutes | Immediate alert |
| **Throttles** | Function throttling | > 0 | Capacity review |
| **Invocations** | Function invocation count | Baseline monitoring | Trend analysis |

#### Infrastructure Metrics
| Metric | Description | Threshold | Alert Action |
|--------|-------------|-----------|--------------|
| **S3 BucketSizeBytes** | Storage utilization | > 80% capacity | Storage review |
| **S3 NumberOfObjects** | Object count | Baseline monitoring | Trend analysis |
| **DynamoDB ConsumedReadCapacity** | Read capacity usage | > 80% | Scale review |
| **DynamoDB ConsumedWriteCapacity** | Write capacity usage | > 80% | Scale review |

### CloudWatch Dashboards

#### Production Dashboard Components
```json
{
  "widgets": [
    {
      "type": "metric",
      "properties": {
        "metrics": [
          ["AWS/Lambda", "Duration", "FunctionName", "kainos-core-prod"],
          ["AWS/Lambda", "Errors", "FunctionName", "kainos-core-prod"],
          ["AWS/Lambda", "Invocations", "FunctionName", "kainos-core-prod"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "eu-west-2",
        "title": "Lambda Performance"
      }
    },
    {
      "type": "log",
      "properties": {
        "query": "SOURCE '/aws/lambda/kainos-core-prod'\n| fields @timestamp, @message\n| filter @message like /ERROR/\n| sort @timestamp desc\n| limit 20",
        "region": "eu-west-2",
        "title": "Recent Errors"
      }
    }
  ]
}
```

### CloudWatch Alarms

#### Critical Alarms
```hcl
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "kainos-core-lambda-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = var.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "kainos-core-lambda-duration-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "25000"
  alarm_description   = "This metric monitors lambda duration"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    FunctionName = var.function_name
  }
}
```

## 🔵 Azure Monitoring Setup

### Application Insights

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **Application Map** | Dependency tracking | Service topology visualization |
| **Live Metrics** | Real-time monitoring | Live performance monitoring |
| **Availability Tests** | Synthetic monitoring | Uptime and response time tracking |
| **Custom Events** | Business metrics | Form submissions, user actions |

#### Application Insights Configuration
```hcl
resource "azurerm_application_insights" "kainos_core" {
  name                = "kainos-core-ai-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = var.retention_days

  tags = {
    Environment = var.environment
    Service     = "kainos-core"
  }
}
```

### Log Analytics Workspace

| Log Type | Purpose | Retention | Query Examples |
|----------|---------|-----------|----------------|
| **FunctionAppLogs** | Function execution logs | 90 days | Error analysis, performance trends |
| **AppServiceHTTPLogs** | HTTP request logs | 30 days | Request patterns, response codes |
| **AppServiceConsoleLogs** | Console output | 30 days | Application debugging |
| **AppServiceAppLogs** | Application logs | 90 days | Custom logging, business events |

#### Log Analytics Queries
```kusto
// Function errors in the last 24 hours
FunctionAppLogs
| where TimeGenerated > ago(24h)
| where Level == "Error"
| summarize count() by bin(TimeGenerated, 1h), FunctionName
| render timechart

// Top 10 slowest requests
AppServiceHTTPLogs
| where TimeGenerated > ago(1h)
| top 10 by TimeTaken desc
| project TimeGenerated, CsUriStem, TimeTaken, ScStatus

// Custom business metrics
customEvents
| where name == "FormSubmission"
| where timestamp > ago(24h)
| summarize count() by bin(timestamp, 1h)
| render timechart
```

### Azure Monitor Alerts

#### Alert Rules Configuration
```hcl
resource "azurerm_monitor_metric_alert" "function_errors" {
  name                = "kainos-core-function-errors-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_function_app.main.id]
  description         = "Alert when function error rate is high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "FunctionExecutionCount"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10

    dimension {
      name     = "Status"
      operator = "Include"
      values   = ["4xx", "5xx"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
```

## 📈 Performance Monitoring

### Key Performance Indicators

#### Application Performance
| KPI | Target | Measurement | Alert Threshold |
|-----|--------|-------------|-----------------|
| **Response Time** | < 2 seconds | 95th percentile | > 3 seconds |
| **Error Rate** | < 0.1% | Percentage of failed requests | > 1% |
| **Availability** | > 99.9% | Uptime percentage | < 99% |
| **Throughput** | Variable | Requests per second | Baseline deviation |

#### Infrastructure Performance
| KPI | Target | Measurement | Alert Threshold |
|-----|--------|-------------|-----------------|
| **Function Duration** | < 5 seconds | Average execution time | > 10 seconds |
| **Memory Usage** | < 80% | Peak memory utilization | > 90% |
| **Storage Usage** | < 75% | Storage capacity used | > 85% |
| **Network Latency** | < 100ms | Round-trip time | > 200ms |

### Performance Dashboards

#### AWS CloudWatch Dashboard
- Lambda function performance metrics
- S3 storage utilization
- DynamoDB performance metrics
- Network and security metrics

#### Azure Application Insights Dashboard
- Application performance overview
- User behavior analytics
- Dependency performance
- Custom business metrics

## 🔍 Log Analysis and Troubleshooting

### Common Log Patterns

#### AWS CloudWatch Insights Queries
```sql
-- Find errors in the last hour
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 50

-- Analyze function performance
fields @timestamp, @duration, @billedDuration, @memorySize, @maxMemoryUsed
| filter @type = "REPORT"
| stats avg(@duration), max(@duration), min(@duration) by bin(5m)

-- Track specific user actions
fields @timestamp, @message
| filter @message like /FormSubmission/
| stats count() by bin(1h)
```

#### Azure Log Analytics Queries
```kusto
// Application errors analysis
AppServiceAppLogs
| where Level == "Error"
| where TimeGenerated > ago(24h)
| summarize count() by bin(TimeGenerated, 1h), Message
| render timechart

// Performance analysis
AppServiceHTTPLogs
| where TimeGenerated > ago(1h)
| summarize avg(TimeTaken), percentile(TimeTaken, 95) by bin(TimeGenerated, 5m)
| render timechart

// User activity tracking
customEvents
| where name in ("PageView", "FormSubmission", "FileUpload")
| where timestamp > ago(24h)
| summarize count() by name, bin(timestamp, 1h)
| render columnchart
```

## 🚨 Alerting Configuration

### Alert Severity Levels

| Severity | Description | Response Time | Escalation |
|----------|-------------|---------------|------------|
| **Critical** | Service unavailable | 5 minutes | Immediate |
| **High** | Performance degradation | 15 minutes | 1 hour |
| **Medium** | Resource warnings | 1 hour | 4 hours |
| **Low** | Informational | 24 hours | Weekly review |

### Notification Channels

#### AWS SNS Topics
```hcl
resource "aws_sns_topic" "critical_alerts" {
  name = "kainos-core-critical-alerts-${var.environment}"
  
  tags = {
    Environment = var.environment
    AlertLevel  = "Critical"
  }
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.critical_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_sns_topic_subscription" "slack_alerts" {
  topic_arn = aws_sns_topic.critical_alerts.arn
  protocol  = "https"
  endpoint  = var.slack_webhook_url
}
```

#### Azure Action Groups
```hcl
resource "azurerm_monitor_action_group" "critical_alerts" {
  name                = "kainos-core-critical-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "kainoscore"

  email_receiver {
    name          = "admin-email"
    email_address = var.admin_email
  }

  webhook_receiver {
    name        = "teams-webhook"
    service_uri = var.teams_webhook_url
  }
}
```

## 📊 Business Metrics Monitoring

### Custom Metrics

#### Form Processing Metrics
| Metric | Description | Collection Method |
|--------|-------------|------------------|
| **Form Submissions** | Number of completed forms | Custom event tracking |
| **File Uploads** | Number of files uploaded | Application logs |
| **User Sessions** | Active user sessions | Session tracking |
| **Processing Time** | Form processing duration | Performance counters |

#### Implementation Examples

##### AWS Custom Metrics
```javascript
// Lambda function custom metrics
const AWS = require('aws-sdk');
const cloudwatch = new AWS.CloudWatch();

async function publishCustomMetric(metricName, value, unit = 'Count') {
    const params = {
        Namespace: 'KainosCore/Application',
        MetricData: [{
            MetricName: metricName,
            Value: value,
            Unit: unit,
            Timestamp: new Date()
        }]
    };
    
    await cloudwatch.putMetricData(params).promise();
}

// Usage
await publishCustomMetric('FormSubmissions', 1);
await publishCustomMetric('ProcessingTime', duration, 'Milliseconds');
```

##### Azure Custom Metrics
```javascript
// Application Insights custom tracking
const appInsights = require('applicationinsights');

// Track custom events
appInsights.defaultClient.trackEvent({
    name: 'FormSubmission',
    properties: {
        formType: 'contact',
        userId: 'user123'
    }
});

// Track custom metrics
appInsights.defaultClient.trackMetric({
    name: 'ProcessingTime',
    value: duration
});
```

## 🔧 Monitoring Best Practices

### Data Retention Policies

| Environment | Log Retention | Metric Retention | Cost Optimization |
|-------------|---------------|------------------|-------------------|
| **Development** | 7 days | 30 days | Minimal retention |
| **Staging** | 30 days | 90 days | Balanced retention |
| **Production** | 90 days | 1 year | Compliance-driven |

### Performance Optimization

#### Query Optimization
- Use time-based filters to limit data scope
- Implement sampling for high-volume metrics
- Cache frequently accessed dashboard data
- Use aggregated metrics for long-term trends

#### Cost Management
- Regular review of log retention policies
- Archive old logs to cheaper storage tiers
- Optimize dashboard refresh frequencies
- Monitor and alert on monitoring costs

## 📋 Monitoring Checklist

### Pre-deployment Monitoring Setup
- [ ] Log groups configured with appropriate retention
- [ ] Custom metrics implementation verified
- [ ] Alert rules configured and tested
- [ ] Dashboard created and validated
- [ ] Notification channels tested
- [ ] Performance baselines established

### Post-deployment Monitoring Validation
- [ ] All metrics flowing correctly
- [ ] Alerts triggering as expected
- [ ] Dashboards displaying accurate data
- [ ] Log aggregation working properly
- [ ] Performance within expected ranges
- [ ] Cost monitoring active

## 📚 References

- **[AWS CloudWatch Documentation](https://docs.aws.amazon.com/cloudwatch/)**
- **[Azure Monitor Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/)**
- **[Application Insights Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)**
- **[AWS Lambda Monitoring Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/lambda-monitoring.html)**
- **[Azure Functions Monitoring](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring)**
