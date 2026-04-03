############################
# IAM Policy Documents
############################

data "aws_iam_policy_document" "this" {
  # S3: sync site content
  statement {
    sid     = "S3SiteContent"
    actions = ["s3:PutObject", "s3:DeleteObject", "s3:GetObject", "s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${var.site_bucket_name}",
      "arn:aws:s3:::${var.site_bucket_name}/*",
    ]
  }

  # CloudFront: cache invalidation
  statement {
    sid       = "CloudFrontInvalidation"
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetDistribution"]
    resources = ["*"]
  }

  # Terraform state: read/write for infra CI
  statement {
    sid     = "TerraformState"
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${var.state_bucket_name}",
      "arn:aws:s3:::${var.state_bucket_name}/*",
    ]
  }
}
