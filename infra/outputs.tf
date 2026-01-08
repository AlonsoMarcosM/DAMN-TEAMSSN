// VPC id for the deployment.
output "vpc_id" {
  value = module.networking.vpc_id
}

// Subnet used by the instance.
output "subnet_id" {
  value = module.networking.subnet_id
}

// SG attached to the honeypot.
output "security_group_id" {
  value = module.honeypot_ec2.security_group_id
}

// EC2 instance id for SSM and troubleshooting.
output "instance_id" {
  value = module.honeypot_ec2.instance_id
}

// Public IP of the honeypot (EIP).
output "public_ip" {
  value = module.honeypot_ec2.public_ip
}

// Elastic IP (same as public_ip, kept for clarity).
output "eip" {
  value = module.honeypot_ec2.eip
}

// S3 bucket where logs are stored.
output "s3_bucket" {
  value = module.s3_logs.bucket_name
}

// SNS topic ARN for alerts.
output "sns_topic_arn" {
  value = module.sns_notifications.topic_arn
}

// Lambda function name.
output "lambda_name" {
  value = module.lambda_analyzer.lambda_name
}

// Lambda function ARN.
output "lambda_arn" {
  value = module.lambda_analyzer.lambda_arn
}

// Log prefix used inside the bucket.
output "cowrie_log_prefix" {
  value = module.honeypot_ec2.s3_log_prefix
}
