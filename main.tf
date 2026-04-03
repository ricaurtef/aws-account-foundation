module "organization" {
  source = "./modules/organization"

  production_account_email = var.production_account_email
  admin_email              = var.admin_email
}

module "identity" {
  source = "./modules/identity"

  github_owner = var.github_owner
}

resource "aws_iam_role_policy" "foundation_pipeline" {
  name   = "foundation-pipeline"
  role   = module.identity.role_name
  policy = data.aws_iam_policy_document.foundation_pipeline.json
}

# Shared deployment role in production — all workload projects chain into this.
# Expand the policy when new projects need new AWS services.
resource "aws_iam_role" "production_deploy" {
  provider = aws.production

  name               = "github-actions-deploy"
  assume_role_policy = data.aws_iam_policy_document.production_deploy_trust.json
}

resource "aws_iam_role_policy" "production_deploy" {
  provider = aws.production

  name   = "workload-deploy"
  role   = aws_iam_role.production_deploy.name
  policy = data.aws_iam_policy_document.production_deploy.json
}
