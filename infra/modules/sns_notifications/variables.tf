variable "topic_name" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "tags" {
  type = map(string)
}
// Variables for the SNS module.
