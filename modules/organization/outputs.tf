############################
# Organization
############################

output "organization_id" {
  description = "ID of the AWS Organization."
  value       = aws_organizations_organization.this.id
}

output "organization_arn" {
  description = "ARN of the AWS Organization."
  value       = aws_organizations_organization.this.arn
}

output "master_account_id" {
  description = "Account ID of the management account."
  value       = aws_organizations_organization.this.master_account_id
}
