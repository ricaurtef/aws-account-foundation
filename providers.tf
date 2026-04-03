provider "aws" {
  region = var.region

  default_tags {
    tags = {
      managed_by  = "terraform"
      project     = "aws-account-foundation"
      repository  = "https://github.com/ricaurtef/aws-account-foundation"
      environment = var.environment
      owner       = var.github_owner
    }
  }
}
