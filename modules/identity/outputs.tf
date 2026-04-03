############################
# IAM Role
############################

output "role_arn" {
  description = "ARN of the IAM role for GitHub Actions."
  value       = module.oidc.role_arn
}

output "role_name" {
  description = "Name of the IAM role for GitHub Actions."
  value       = module.oidc.role_name
}

############################
# OIDC Provider
############################

output "provider_arn" {
  description = "ARN of the OIDC identity provider."
  value       = module.oidc.provider_arn
}
