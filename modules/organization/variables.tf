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
