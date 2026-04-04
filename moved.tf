############################
# Organizations
############################

moved {
  from = module.organization.aws_organizations_organization.this
  to   = aws_organizations_organization.this
}

moved {
  from = module.organization.aws_organizations_account.this_production
  to   = aws_organizations_account.this_production
}

############################
# SSO / Identity Store
############################

moved {
  from = module.organization.aws_ssoadmin_permission_set.this_admin
  to   = aws_ssoadmin_permission_set.this_admin
}

moved {
  from = module.organization.aws_ssoadmin_managed_policy_attachment.this_admin
  to   = aws_ssoadmin_managed_policy_attachment.this_admin
}

moved {
  from = module.organization.aws_identitystore_user.this_admin
  to   = aws_identitystore_user.this_admin
}

moved {
  from = module.organization.aws_ssoadmin_account_assignment.this_production_admin
  to   = aws_ssoadmin_account_assignment.this_production_admin
}

############################
# OIDC
############################

moved {
  from = module.identity.module.oidc
  to   = module.oidc
}
