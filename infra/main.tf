# Shared locals and defaults for the whole stack.

// Latest Amazon Linux 2023 AMI (used when ami_id is empty).
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Current AWS account id (used for unique bucket names).
data "aws_caller_identity" "current" {}

// Project-wide settings and derived names.
locals {
  project_prefix  = "proy-damn-teamssn"
  team_name       = "DAMN-TEAMSSN"
  env             = "dev"
  resource_suffix = lower(var.resource_suffix)
  vpc_cidr        = "10.0.0.0/16"
  subnet_cidr     = "10.0.1.0/24"

  tags = {
    Project = local.team_name
    Owner   = local.resource_suffix
    Env     = local.env
  }

  s3_bucket_name   = "${local.project_prefix}-logs-${local.resource_suffix}-${data.aws_caller_identity.current.account_id}"
  sns_topic_name   = "${local.project_prefix}-alerts-${local.resource_suffix}"
  lambda_name      = "${local.project_prefix}-analyzer-${local.resource_suffix}"
  effective_ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.al2023.id
}

// 1) Networking: VPC + subnet + route + IGW.
module "networking" {
  source = "./modules/networking"

  project_prefix  = local.project_prefix
  resource_suffix = local.resource_suffix
  vpc_cidr        = local.vpc_cidr
  subnet_cidr     = local.subnet_cidr
  az              = var.az
  tags            = local.tags
}

// 2) S3 logs bucket for Cowrie outputs.
module "s3_logs" {
  source = "./modules/s3_logs"

  bucket_name = local.s3_bucket_name
  expire_days = var.s3_log_expire_days
  tags        = local.tags
}

// 3) SNS notifications (email alerts).
module "sns_notifications" {
  source = "./modules/sns_notifications"

  topic_name  = local.sns_topic_name
  admin_email = var.admin_email
  tags        = local.tags
}

// 4) Lambda analyzer (process logs and send alerts).
module "lambda_analyzer" {
  source = "./modules/lambda_analyzer"

  function_name    = local.lambda_name
  s3_bucket_name   = module.s3_logs.bucket_name
  s3_bucket_arn    = module.s3_logs.bucket_arn
  sns_topic_arn    = module.sns_notifications.topic_arn
  threshold_total  = var.threshold_total
  threshold_per_ip = var.threshold_per_ip
  existing_role_arn = var.existing_lambda_role_arn
  tags             = local.tags
}

// 5) Honeypot EC2 (Cowrie).
module "honeypot_ec2" {
  source = "./modules/honeypot_ec2"

  project_prefix     = local.project_prefix
  resource_suffix    = local.resource_suffix
  vpc_id             = module.networking.vpc_id
  subnet_id          = module.networking.subnet_id
  allowed_admin_cidr = var.allowed_admin_cidr
  instance_type      = var.instance_type
  ami_id             = local.effective_ami_id
  key_name           = var.key_name
  enable_ssm         = var.enable_ssm
  existing_instance_profile_name = var.existing_instance_profile_name
  aws_region         = var.aws_region
  s3_bucket_name     = module.s3_logs.bucket_name
  tags               = local.tags
}

// 6) CloudWatch alarms for EC2 health.
module "cloudwatch" {
  source = "./modules/cloudwatch"

  instance_id   = module.honeypot_ec2.instance_id
  sns_topic_arn = module.sns_notifications.topic_arn
  tags          = local.tags
}
