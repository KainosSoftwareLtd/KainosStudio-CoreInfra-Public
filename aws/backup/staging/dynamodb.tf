resource "aws_dynamodb_table" "core_form_sessions" {
  name                        = local.dynamodb_core_form_sessions_table_name
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true


  hash_key  = "form_id"
  range_key = "session_id"

  attribute {
    name = "form_id"
    type = "S"
  }

  attribute {
    name = "session_id"
    type = "S"
  }

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = data.aws_kms_alias.cw.target_key_arn
  }

  tags = {
    Environment = var.env
    Name        = local.dynamodb_core_form_sessions_table_name
  }
}