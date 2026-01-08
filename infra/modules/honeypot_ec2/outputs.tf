// EC2 instance id.
output "instance_id" {
  value = aws_instance.honeypot.id
}

// Public IP (EIP) for the honeypot.
output "public_ip" {
  value = aws_eip.honeypot.public_ip
}

// Elastic IP allocation (same as public_ip).
output "eip" {
  value = aws_eip.honeypot.public_ip
}

// Security group id.
output "security_group_id" {
  value = aws_security_group.honeypot.id
}

// S3 prefix used for logs.
output "s3_log_prefix" {
  value = local.s3_prefix
}
