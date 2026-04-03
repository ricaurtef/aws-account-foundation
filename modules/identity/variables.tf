############################
# OIDC Federation
############################

variable "github_owner" {
  description = "GitHub account owner. All repos under this account can assume the OIDC role on main."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.github_owner))
    error_message = "Must be a valid GitHub username (alphanumeric and hyphens only)."
  }
}
