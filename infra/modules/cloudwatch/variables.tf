variable "instance_id" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
