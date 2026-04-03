############################
# Organization
############################

variable "organization_feature_set" {
  description = "Feature set for the AWS Organization (ALL or CONSOLIDATED_BILLING)."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "CONSOLIDATED_BILLING"], var.organization_feature_set)
    error_message = "Must be ALL or CONSOLIDATED_BILLING."
  }
}

############################
# Member Accounts
############################

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
