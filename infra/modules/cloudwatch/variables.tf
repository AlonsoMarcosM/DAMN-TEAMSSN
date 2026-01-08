variable "instance_id" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
// Variables for CloudWatch alarms.
