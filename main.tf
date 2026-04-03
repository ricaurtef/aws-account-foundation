module "organization" {
  source = "./modules/organization"

  production_account_email = var.production_account_email
  admin_email              = var.admin_email
}

module "identity" {
  source = "./modules/identity"

  github_owner = var.github_owner

  providers = {
    aws = aws.production
  }
}
