variable "function_name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "threshold_total" {
  type = number
}

variable "threshold_per_ip" {
  type = number
}

variable "tags" {
  type = map(string)
}
