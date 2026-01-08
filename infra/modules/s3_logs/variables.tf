variable "bucket_name" {
  type = string
}

variable "expire_days" {
  type = number
}

variable "tags" {
  type = map(string)
}
// Variables for the S3 logs module.
