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
