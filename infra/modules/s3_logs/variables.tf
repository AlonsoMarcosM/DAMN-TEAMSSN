variable "bucket_name" {
  type = string
}

variable "expire_days" {
  type = number
}

variable "tags" {
  type = map(string)
}
