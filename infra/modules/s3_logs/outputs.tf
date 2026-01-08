// Bucket name for logs.
output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}

// Bucket ARN for IAM policies.
output "bucket_arn" {
  value = aws_s3_bucket.logs.arn
}
