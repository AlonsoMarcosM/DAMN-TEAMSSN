variable "project_prefix" {
  type = string
}

variable "resource_suffix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "az" {
  type = string
}

variable "tags" {
  type = map(string)
}
// Variables for the networking module.
