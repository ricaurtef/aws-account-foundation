############################
# Organization
############################

output "organization_id" {
  description = "ID of the AWS Organization."
  value       = module.organization.organization_id
}

output "production_account_id" {
  description = "Account ID of the production workload account."
  value       = module.organization.production_account_id
}

############################
# Identity
############################

output "role_arn" {
  description = "ARN of the OIDC role (management account)."
  value       = module.identity.role_arn
}

output "production_deploy_role_arn" {
  description = "ARN of the shared deployment role in the production account."
  value       = aws_iam_role.production_deploy.arn
}
