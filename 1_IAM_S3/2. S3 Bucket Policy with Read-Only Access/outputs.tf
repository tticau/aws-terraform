output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "Name of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the S3 bucket"
}

output "website_endpoint" {
  value       = var.enable_website ? aws_s3_bucket_website_configuration.this[0].website_endpoint : ""
  description = "S3 website endpoint"
}

output "object_url" {
  description = "Direct object URL vi S3 REST API"
  value       = "https://${aws_s3_bucket.this.bucket}.s3.${var.region}.amazonaws.com/index.html"
}