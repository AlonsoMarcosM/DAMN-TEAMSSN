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

variable "resource_suffix" {
  type        = string
  description = "Unique suffix per student (amm, nlr, mpg, dtm)."
}

variable "admin_email" {
  type        = string
  description = "Admin email address for SNS notifications."
}

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
  description = "AMI ID for the honeypot instance. Leave empty to use latest Amazon Linux 2023."
  default     = "ami-052064a798f08f0d3"
}

variable "key_name" {
  type        = string
  description = "Optional SSH key pair name."
  default     = ""
}

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

variable "enable_ssm" {
  type        = bool
  description = "Enable SSM access and disable SSH daemon."
  default     = true
}
