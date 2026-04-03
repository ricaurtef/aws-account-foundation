module "organization" {
  source = "./modules/organization"
}

module "identity" {
  source = "./modules/identity"

  github_owner = var.github_owner
}
