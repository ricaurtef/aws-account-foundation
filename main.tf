############################
# Foundation Pipeline Policy
############################

resource "aws_iam_role_policy" "foundation_pipeline" {
  name   = "foundation-pipeline"
  role   = module.oidc.role_name
  policy = data.aws_iam_policy_document.foundation_pipeline.json
}

############################
# Production Deployment Role
############################

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
