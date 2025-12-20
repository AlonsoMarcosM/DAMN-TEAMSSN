output "instance_id" {
  value = aws_instance.honeypot.id
}

output "public_ip" {
  value = aws_eip.honeypot.public_ip
}

output "eip" {
  value = aws_eip.honeypot.public_ip
}

output "security_group_id" {
  value = aws_security_group.honeypot.id
}

output "s3_log_prefix" {
  value = local.s3_prefix
}
