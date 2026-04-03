resource "aws_organizations_organization" "this" {
  feature_set = var.organization_feature_set

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]
}
