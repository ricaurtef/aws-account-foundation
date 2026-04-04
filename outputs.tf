############################
# Organization
############################

output "organization_id" {
  description = "ID of the AWS Organization."
  value       = aws_organizations_organization.this.id
}

output "production_account_id" {
  description = "Account ID of the production workload account."
  value       = aws_organizations_account.this_production.id
}

############################
# Identity
############################

output "role_arn" {
  description = "ARN of the OIDC role (management account)."
  value       = module.oidc.role_arn
}

output "production_deploy_role_arn" {
  description = "ARN of the shared deployment role in the production account."
  value       = aws_iam_role.production_deploy.arn
}
