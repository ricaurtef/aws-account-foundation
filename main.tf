module "organization" {
  source = "./modules/organization"
}

module "identity" {
  source = "./modules/identity"

  github_owner      = var.github_owner
  site_bucket_name  = var.site_bucket_name
  state_bucket_name = var.state_bucket_name
}
