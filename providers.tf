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

provider "aws" {
  alias  = "production"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.production_account_id}:role/OrganizationAccountAccessRole"
  }

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
