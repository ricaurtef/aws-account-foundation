############################
# Identity Center
############################

locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_ssoadmin_permission_set" "this_admin" {
  name         = "AdministratorAccess"
  instance_arn = local.sso_instance_arn

  session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "this_admin" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this_admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_identitystore_user" "this_admin" {
  identity_store_id = local.identity_store_id

  user_name          = "rricaurte"
  display_name       = "Ruben Ricaurte"
  nickname           = "Rubinho"
  locale             = "AR"
  timezone           = "America/Argentina/Buenos_Aires"
  preferred_language = "English, spanish and portuguese."

  name {
    given_name  = "Ruben"
    family_name = "Ricaurte"
  }

  emails {
    value   = var.admin_email
    primary = true
    type    = "work"
  }
}

############################
# Account Assignments
############################

resource "aws_ssoadmin_account_assignment" "this_production_admin" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this_admin.arn

  principal_id   = aws_identitystore_user.this_admin.user_id
  principal_type = "USER"

  target_id   = aws_organizations_account.this_production.id
  target_type = "AWS_ACCOUNT"
}
