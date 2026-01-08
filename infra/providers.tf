// AWS provider configuration (profile optional).
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null
}
