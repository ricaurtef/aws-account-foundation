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

variable "environment" {
  description = "Deployment environment (e.g., production, staging)."
  type        = string

  validation {
    condition     = contains(["production", "staging", "development"], var.environment)
    error_message = "Must be one of: production, staging, development."
  }
}

############################
# Accounts
############################

variable "production_account_id" {
  description = "AWS account ID of the production workload account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.production_account_id))
    error_message = "Must be a 12-digit AWS account ID."
  }
}

variable "production_account_email" {
  description = "Email address for the production member account."
  type        = string

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.[^@]+$", var.production_account_email))
    error_message = "Must be a valid email address."
  }
}

############################
# Identity Center
############################

variable "admin_email" {
  description = "Email address for the admin Identity Center user."
  type        = string

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.[^@]+$", var.admin_email))
    error_message = "Must be a valid email address."
  }
}

############################
# Identity (OIDC)
############################

variable "github_owner" {
  description = "GitHub account owner for OIDC federation."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.github_owner))
    error_message = "Must be a valid GitHub username (alphanumeric and hyphens only)."
  }
}
