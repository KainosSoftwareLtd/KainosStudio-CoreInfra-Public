data "archive_file" "lambda_alerts_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-alerts"
  output_path = "${path.module}/lambda-alerts/lambda-alerts.zip"
}