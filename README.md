<!-- BEGIN_TF_DOCS -->
# AWS Account Foundation

![tag](https://img.shields.io/github/v/tag/ricaurtef/aws-account-foundation?label=tag&color=fe8019)
![ci](https://img.shields.io/github/actions/workflow/status/ricaurtef/aws-account-foundation/terraform.yml?label=ci&color=83a598)
![terraform](https://img.shields.io/badge/terraform-~%3E1.14-623CE4?logo=terraform&logoColor=white)
![aws provider](https://img.shields.io/badge/aws_provider-~%3E6.27-232F3E?logo=amazonaws&logoColor=white)
![license](https://img.shields.io/github/license/ricaurtef/aws-account-foundation?color=83a598)

---

Provisions the foundational layer of a personal AWS account: Organizations, IAM Identity Center,
OIDC federation for GitHub Actions, and the Terraform state bucket. Everything that needs to exist
before workload-specific infrastructure can be deployed.

## Architecture

```mermaid
block-beta
  columns 2

  block:org:2["AWS Organization (management account)"]
    columns 2

    block:sso["IAM Identity Center (SSO)"]
    end

    block:oidc["OIDC Federation"]
      p["Provider: GitHub Actions"]
      t["Trust: ricaurtef/*:main"]
      r["Role: no policies (generic)"]
    end

    block:s3:2["S3: ricaurtef-terraform-state\n(versioned, KMS encrypted, public access blocked)"]
    end
  end
```

## Repository structure

```
aws-account-foundation/
├── modules/
│   ├── identity/          # OIDC federation + IAM deploy role
│   └── organization/      # AWS Organizations + policy types
├── setup/
│   └── bootstrap/         # State bucket (manual, one-time)
├── env/
│   └── production.tfvars    # Environment-specific values
├── .config/               # Integration tooling configs
├── .github/workflows/     # CI/CD pipeline
├── main.tf                # Module orchestration
├── variables.tf           # Root variables (no defaults — driven by tfvars)
├── outputs.tf             # Root outputs
├── providers.tf           # AWS provider
├── backend.tf             # S3 backend (partial — populated at init time)
└── versions.tf            # Terraform + provider version constraints
```

## Modules

### identity

Deploys OIDC federation for GitHub Actions using
[`terraform-aws-oidc-federation`](https://github.com/ricaurtef/terraform-aws-oidc-federation).
Creates a single IAM role that any repo under `ricaurtef/*` can assume from `main`. The role
is created without policies — each workload project attaches its own permissions via the
`role_name` output.

### organization

Manages the AWS Organization resource with SCP and tag policy types enabled.

## Prerequisites

- An AWS account with an Organization already created.
- Local AWS credentials with admin access (for the one-time bootstrap).
- GitHub repository secrets/variables (configured during bootstrap):
  - `AWS_ROLE_ARN` (repository variable) — the OIDC role ARN.
  - `ANTHROPIC_API_KEY` (repository secret) — for Claude code review.

## Bootstrap

The pipeline depends on OIDC federation, which is deployed by this project. To break the
chicken-and-egg cycle, the first deployment is manual. After that, the pipeline is
self-sustaining.

**Step 1 — Create the state bucket:**

```bash
cd setup/bootstrap
terraform init
terraform apply
```

**Step 2 — Deploy the foundation (creates the OIDC role):**

```bash
cd ../..
terraform init \
  -backend-config="bucket=ricaurtef-terraform-state" \
  -backend-config="key=personal/us-east-1/account-foundation/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true" \
  -backend-config="use_lockfile=true"

terraform apply -var-file=env/production.tfvars
```

**Step 3 — Enable the pipeline:**

Copy the `role_arn` output and set it as a GitHub repository variable:

```bash
gh variable set AWS_ROLE_ARN --body "$(terraform output -raw role_arn)" --repo ricaurtef/aws-account-foundation
```

From this point forward, all changes go through the CI/CD pipeline.

## CI/CD pipeline

```mermaid
flowchart TD
  subgraph pr["PR opened/updated"]
    direction TB
    gates1["check | validate | tflint | security"]
    gates1 --> plan["plan (review)"]
  end

  subgraph merge["Merge to main"]
    direction TB
    gates2["check | validate | tflint | security"]
    gates2 --> deploy["deploy (production)\nplan → ⏸️ approve → apply"]
    deploy --> release["release (auto-tag)"]
  end
```

- **PR:** quality gates + plan for review.
- **Merge:** quality gates + deploy with `production` environment approval gate + automatic release.
- Backend config injected at `terraform init` via `-backend-config` flags.
- Environment values from `env/production.tfvars` via `-var-file`.

## Required tools

| Tool | Purpose |
|------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | Infrastructure as Code |
| [terraform-docs](https://terraform-docs.io/user-guide/installation/) | README generation |
| [TFLint](https://github.com/terraform-linters/tflint#installation) | Terraform linter |
| [Checkov](https://www.checkov.io/2.Basics/Installing%20Checkov.html) | Security / policy scanning |
| [Trivy](https://aquasecurity.github.io/trivy/latest/getting-started/installation/) | Vulnerability / secret scanning |
| [pre-commit](https://pre-commit.com/#installation) | Git hook manager |

> Once all tools are installed, run `make setup` to initialise pre-commit hooks, TFLint plugins,
> and the Terraform working directory.

## Releasing

Releases are automated after a successful deploy. Each merge to `main` that passes the
`production` approval gate gets a patch version bump and a GitHub Release with auto-generated
notes.

The version is derived from the latest `v*.*.*` tag. The first release starts at `v1.0.0`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.27 |
## Providers

No providers.
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_identity"></a> [identity](#module\_identity) | ./modules/identity | n/a |
| <a name="module_organization"></a> [organization](#module\_organization) | ./modules/organization | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment (e.g., production, staging). | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub account owner for OIDC federation. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_organization_id"></a> [organization\_id](#output\_organization\_id) | ID of the AWS Organization. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role for GitHub Actions. |
<!-- END_TF_DOCS -->