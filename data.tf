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

  # STS: identity verification + cross-account assume
  statement {
    sid = "STS"
    actions = [
      "sts:GetCallerIdentity",
      "sts:AssumeRole",
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
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [module.identity.role_arn]
    }
  }
}

# Permissions: services needed by workload projects (expandable).
data "aws_iam_policy_document" "production_deploy" {
  # S3: site content + workload state
  statement {
    sid = "S3"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetBucketLogging",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:PutBucketOwnershipControls",
      "s3:GetBucketOwnershipControls",
    ]

    resources = ["*"]
  }

  # CloudFront: distribution + functions
  statement {
    sid = "CloudFront"
    actions = [
      "cloudfront:GetDistribution",
      "cloudfront:CreateDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:GetFunction",
      "cloudfront:CreateFunction",
      "cloudfront:UpdateFunction",
      "cloudfront:DeleteFunction",
      "cloudfront:DescribeFunction",
      "cloudfront:PublishFunction",
      "cloudfront:ListDistributions",
    ]

    resources = ["*"]
  }

  # ACM: TLS certificates
  statement {
    sid = "ACM"
    actions = [
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:DeleteCertificate",
      "acm:AddTagsToCertificate",
      "acm:ListTagsForCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
    ]

    resources = ["*"]
  }

  # Route 53: DNS records
  statement {
    sid = "Route53"
    actions = [
      "route53:GetHostedZone",
      "route53:CreateHostedZone",
      "route53:DeleteHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZones",
      "route53:ChangeTagsForResource",
      "route53:ListTagsForResource",
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
