variable "project_prefix" {
  type = string
}

variable "resource_suffix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "allowed_admin_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "existing_instance_profile_name" {
  type    = string
  default = ""
}

variable "enable_ssm" {
  type = bool
}

variable "aws_region" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "admin_ssh_port" {
  type    = number
  default = 22222
}

variable "enable_telnet" {
  type    = bool
  default = false
}
