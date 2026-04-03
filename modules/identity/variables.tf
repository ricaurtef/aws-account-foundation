############################
# OIDC Federation
############################

variable "github_owner" {
  description = "GitHub account owner. All repos under this account can assume the OIDC role on main."
  type        = string

  validation {
    condition     = length(var.github_owner) > 0
    error_message = "GitHub owner must not be empty."
  }
}

############################
# S3 Buckets
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
