# Import existing Organization and Identity Center.
#
# After initial deploy, import with:
#   terraform import 'module.organization.aws_organizations_organization.this' <org-id>
#
# Identity Center resources will be imported in a future iteration.

resource "aws_organizations_organization" "this" {
  feature_set = var.organization_feature_set

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]
}
