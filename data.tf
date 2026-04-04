############################
# Foundation Pipeline Policy
############################

data "aws_iam_policy_document" "foundation_pipeline" {
  # S3: Terraform state read/write
  statement {
    sid = "TerraformState"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::ricaurtef-terraform-state",
      "arn:aws:s3:::ricaurtef-terraform-state/*",
    ]
  }

  # Organizations: manage accounts and policies
  statement {
    sid = "Organizations"
    actions = [
      "organizations:Describe*",
      "organizations:List*",
      "organizations:CreateAccount",
      "organizations:EnablePolicyType",
      "organizations:DisablePolicyType",
      "organizations:EnableAWSServiceAccess",
      "organizations:DisableAWSServiceAccess",
      "organizations:TagResource",
      "organizations:UntagResource",
    ]

    resources = ["*"]
  }

  # SSO: manage permission sets and account assignments
  statement {
    sid = "SSOAdmin"
    actions = [
      "sso:Describe*",
      "sso:List*",
      "sso:GetPermissionSet",
      "sso:CreatePermissionSet",
      "sso:UpdatePermissionSet",
      "sso:DeletePermissionSet",
      "sso:ProvisionPermissionSet",
      "sso:CreateAccountAssignment",
      "sso:DeleteAccountAssignment",
      "sso:AttachManagedPolicyToPermissionSet",
      "sso:DetachManagedPolicyFromPermissionSet",
      "sso:TagResource",
      "sso:UntagResource",
    ]

    resources = ["*"]
  }

  # Identity Store: manage users
  statement {
    sid = "IdentityStore"
    actions = [
      "identitystore:Describe*",
      "identitystore:List*",
      "identitystore:GetUserId",
      "identitystore:CreateUser",
      "identitystore:UpdateUser",
      "identitystore:DeleteUser",
    ]

    resources = ["*"]
  }

  # IAM: manage OIDC providers and roles (self-management)
  statement {
    sid = "IAM"
    actions = [
      "iam:GetOpenIDConnectProvider",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:GetRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListInstanceProfilesForRole",
    ]

    resources = ["*"]
  }

  # Route 53 Domains: nameserver delegation from management registrar
  statement {
    sid = "Route53Domains"
    actions = [
      "route53domains:GetDomainDetail",
      "route53domains:GetOperationDetail",
      "route53domains:UpdateDomainNameservers",
      "route53domains:EnableDomainTransferLock",
      "route53domains:DisableDomainTransferLock",
      "route53domains:UpdateDomainContact",
      "route53domains:UpdateDomainContactPrivacy",
      "route53domains:EnableDomainAutoRenew",
      "route53domains:DisableDomainAutoRenew",
      "route53domains:ListTagsForDomain",
      "route53domains:UpdateTagsForDomain",
      "route53domains:DeleteTagsForDomain",
    ]

    resources = ["*"]
  }

  # STS: identity verification + cross-account assume
  statement {
    sid = "STS"
    actions = [
      "sts:GetCallerIdentity",
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    resources = [
      "*",
      "arn:aws:iam::${var.production_account_id}:role/github-actions-deploy",
    ]
  }
}

############################
# Production Deployment Role
############################

# Trust policy: only the management OIDC role can assume this role.
data "aws_iam_policy_document" "production_deploy_trust" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "AWS"
      identifiers = [module.identity.role_arn]
    }
  }
}

# Permissions: services needed by workload projects (expandable).
# Strategy: read wildcards (Get*, List*, Describe*) + explicit writes.
data "aws_iam_policy_document" "production_deploy" {
  # S3: site content + workload state
  statement {
    sid = "S3Read"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "S3Write"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketAcl",
      "s3:PutBucketTagging",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketEncryption",
      "s3:PutBucketVersioning",
      "s3:PutLifecycleConfiguration",
      "s3:PutBucketOwnershipControls",
      "s3:PutEncryptionConfiguration",
    ]

    resources = ["*"]
  }

  # CloudFront: distribution + functions
  statement {
    sid = "CloudFrontRead"
    actions = [
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudfront:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudFrontWrite"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:CreateInvalidation",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:CreateFunction",
      "cloudfront:UpdateFunction",
      "cloudfront:DeleteFunction",
      "cloudfront:PublishFunction",
    ]

    resources = ["*"]
  }

  # ACM: TLS certificates
  statement {
    sid = "ACMRead"
    actions = [
      "acm:Describe*",
      "acm:Get*",
      "acm:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ACMWrite"
    actions = [
      "acm:RequestCertificate",
      "acm:DeleteCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:RenewCertificate",
      "acm:UpdateCertificateOptions",
    ]

    resources = ["*"]
  }

  # Route 53: DNS records
  statement {
    sid = "Route53Read"
    actions = [
      "route53:Get*",
      "route53:List*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Route53Write"
    actions = [
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:ChangeTagsForResource",
      "route53:UpdateHostedZoneComment",
    ]

    resources = ["*"]
  }

  # CloudWatch: dashboards + metrics
  statement {
    sid = "CloudWatchRead"
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:Describe*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudWatchWrite"
    actions = [
      "cloudwatch:PutDashboard",
      "cloudwatch:DeleteDashboards",
      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
    ]

    resources = ["*"]
  }

  # STS: identity verification
  statement {
    sid       = "STS"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}
