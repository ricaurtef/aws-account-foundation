module "oidc" {
  source = "git::https://github.com/ricaurtef/terraform-aws-oidc-federation.git?ref=3d6b8115475699d23d8601c8fc3bebd73f0b4b9c" # v1.0.0

  platform     = "github"
  match_values = ["repo:${var.github_owner}/*:ref:refs/heads/main"]
}

resource "aws_iam_role_policy" "this" {
  name   = "github-actions-deploy"
  role   = module.oidc.role_name
  policy = data.aws_iam_policy_document.this.json
}
