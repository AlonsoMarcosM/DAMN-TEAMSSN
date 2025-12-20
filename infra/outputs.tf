output "vpc_id" {
  value = module.networking.vpc_id
}

output "subnet_id" {
  value = module.networking.subnet_id
}

output "security_group_id" {
  value = module.honeypot_ec2.security_group_id
}

output "instance_id" {
  value = module.honeypot_ec2.instance_id
}

output "public_ip" {
  value = module.honeypot_ec2.public_ip
}

output "eip" {
  value = module.honeypot_ec2.eip
}

output "s3_bucket" {
  value = module.s3_logs.bucket_name
}

output "sns_topic_arn" {
  value = module.sns_notifications.topic_arn
}

output "lambda_name" {
  value = module.lambda_analyzer.lambda_name
}

output "lambda_arn" {
  value = module.lambda_analyzer.lambda_arn
}

output "cowrie_log_prefix" {
  value = module.honeypot_ec2.s3_log_prefix
}
