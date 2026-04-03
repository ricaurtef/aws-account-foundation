############################
# Organization
############################

output "organization_id" {
  description = "ID of the AWS Organization."
  value       = module.organization.organization_id
}

############################
# Identity
############################

output "role_arn" {
  description = "ARN of the IAM role for GitHub Actions."
  value       = module.identity.role_arn
}
