// AWS and region settings.
variable "aws_profile" {
  type        = string
  description = "Optional AWS CLI profile. Leave empty to use default."
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region for the lab."
  default     = "us-east-1"
}

variable "az" {
  type        = string
  description = "Availability zone for the public subnet."
  default     = "us-east-1a"
}

// Naming and notifications.
variable "resource_suffix" {
  type        = string
  description = "Unique suffix per student (amm, nlr, mpg, dtm)."
}

variable "admin_email" {
  type        = string
  description = "Admin email address for SNS notifications."
}

// Access and instance configuration.
variable "allowed_admin_cidr" {
  type        = string
  description = "CIDR allowed for admin SSH if SSM is disabled."
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for Cowrie."
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the honeypot instance. Leave empty to use latest Amazon Linux 2023 kernel 6.1."
  default     = ""
}

variable "key_name" {
  type        = string
  description = "Optional SSH key pair name."
  default     = ""
}

// IAM reuse (for restricted lab accounts).
variable "existing_instance_profile_name" {
  type        = string
  description = "Existing IAM instance profile name to attach to EC2. Leave empty to create a new role/profile."
  default     = ""
}

variable "existing_lambda_role_arn" {
  type        = string
  description = "Existing IAM role ARN for Lambda. Leave empty to create a new role."
  default     = ""
}

// Alert thresholds and log retention.
variable "threshold_total" {
  type        = number
  description = "Total events threshold for alerting."
  default     = 20
}

variable "threshold_per_ip" {
  type        = number
  description = "Per-IP events threshold for alerting."
  default     = 10
}

variable "s3_log_expire_days" {
  type        = number
  description = "Number of days to retain logs in S3."
  default     = 30
}

// Admin access preference.
variable "enable_ssm" {
  type        = bool
  description = "Enable SSM access and disable SSH daemon."
  default     = true
}
