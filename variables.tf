############################
# General
############################

variable "region" {
  description = "AWS region."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "Must be a valid AWS region (e.g., us-east-1)."
  }
}

############################
# Identity
############################

variable "github_owner" {
  description = "GitHub account owner for OIDC federation."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.github_owner))
    error_message = "Must be a valid GitHub username (alphanumeric and hyphens only)."
  }
}

############################
# S3
############################

variable "site_bucket_name" {
  description = "Name of the S3 bucket for site content."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.site_bucket_name))
    error_message = "Must be a valid S3 bucket name (lowercase, 3-63 chars, no underscores)."
  }
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "Must be a valid S3 bucket name (lowercase, 3-63 chars, no underscores)."
  }
}
