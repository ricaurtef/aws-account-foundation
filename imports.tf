############################
# Organization
############################

# import {
#   to = module.organization.aws_organizations_organization.this
#   id = "o-34774fszn4"
# }

############################
# Member Accounts
############################

# import {
#   to = module.organization.aws_organizations_account.this_production
#   id = "839765241276"
# }

############################
# Identity Center
############################

# import {
#   to = module.organization.aws_ssoadmin_permission_set.this_admin
#   id = "arn:aws:sso:::permissionSet/ssoins-72234ad96ea63aa5/ps-03ea1a7a76fe0754,arn:aws:sso:::instance/ssoins-72234ad96ea63aa5"
# }

# import {
#   to = module.organization.aws_identitystore_user.this_admin
#   id = "d-90662086b9/34280458-00d1-70fe-ba5a-f25b953d3009"
# }

# import {
#   to = module.organization.aws_ssoadmin_managed_policy_attachment.this_admin
#   id = "arn:aws:iam::aws:policy/AdministratorAccess,arn:aws:sso:::permissionSet/ssoins-72234ad96ea63aa5/ps-03ea1a7a76fe0754,arn:aws:sso:::instance/ssoins-72234ad96ea63aa5"
# }

# import {
#   to = module.organization.aws_ssoadmin_account_assignment.this_production_admin
#   id = "34280458-00d1-70fe-ba5a-f25b953d3009,USER,839765241276,AWS_ACCOUNT,arn:aws:sso:::permissionSet/ssoins-72234ad96ea63aa5/ps-03ea1a7a76fe0754,arn:aws:sso:::instance/ssoins-72234ad96ea63aa5"
# }
