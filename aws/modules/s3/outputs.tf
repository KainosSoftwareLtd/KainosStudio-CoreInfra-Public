output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The DNS name of the bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional DNS name of the bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "The hosted zone ID of the bucket."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "tags" {
  description = "Tags assigned to the bucket."
  value       = aws_s3_bucket.this.tags
}
