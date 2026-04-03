module "oidc" {
  source = "git::https://github.com/ricaurtef/terraform-aws-oidc-federation.git?ref=3d6b8115475699d23d8601c8fc3bebd73f0b4b9c" # v1.0.0

  platform = "github"
  match_values = [
    "repo:${var.github_owner}/*:ref:refs/heads/main",
    "repo:${var.github_owner}/*:pull_request",
  ]
}
