############################
# General
############################

variable "region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "us-east-1"
}

############################
# State Bucket
############################

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state."
  type        = string
  default     = "ricaurtef-terraform-state"
}
