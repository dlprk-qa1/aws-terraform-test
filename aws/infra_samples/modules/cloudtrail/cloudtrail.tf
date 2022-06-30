##################################################### Compliant Resources ######################################################################

data "aws_caller_identity" "current" {}

locals {
  account_id                    = data.aws_caller_identity.current.account_id
}

# IAM policy for Cloudtrail to assume role
data "aws_iam_policy_document" "compliant_cloudtrail_assume_role_policy" {
  version                       = "2012-10-17"

  statement {
      effect                    = "Allow"
      principals {
          type                  = "Service"
          identifiers           = ["cloudtrail.amazonaws.com"]
      }
      actions                   = ["sts:AssumeRole"]
  }
}

# IAM policy for Cloudtrail to create log stream and push logs to it
data "aws_iam_policy_document" "compliant_cloudtrail_policy" {
  version                       = "2012-10-17"

  statement {
      sid                       = "AWSCloudTrailCreateLogStream"
      effect                    = "Allow"
      actions                   = ["logs:CreateLogStream"]
      resources                 = ["${var.log_group_arn}*"]
  }
  statement {
      sid                       = "AWSCloudTrailPutLogEvents"
      effect                    = "Allow"
      actions                   = ["logs:PutLogEvents"]
      resources                 = ["${var.log_group_arn}*"]
  }
}

resource "aws_iam_role" "compliant_cloudtrail_iam_role" {
  count                         = var.infra_type == "compliant" ? var.var_count : 0
  name                          = "${var.env_name}-${var.infra_type}-cloudtrail-iam-role-${count.index + 1}"
  assume_role_policy            = data.aws_iam_policy_document.compliant_cloudtrail_assume_role_policy.json

  inline_policy {
    name                        = "${var.env_name}-${var.infra_type}-cloudtrail-role-${count.index + 1}-policy"
    policy                      = data.aws_iam_policy_document.compliant_cloudtrail_policy.json
  }
}

resource "aws_cloudtrail" "compliant_cloudtrail" {
  name                          = "${var.env_name}-${var.infra_type}-cloudtrail-${count.index + 1}"
  count                         = var.infra_type == "compliant" ? var.var_count : 0
  s3_bucket_name                = var.s3_bucket
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${var.log_group_arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.compliant_cloudtrail_iam_role[count.index].arn
  enable_logging                = true
  enable_log_file_validation    = true
  kms_key_id                    = var.kms_key
  tags = {
    Name                        = "${var.env_name}-${var.infra_type}-cloudtrail-${count.index + 1}"
  }
}

####################################################### Non-Compliant Resources ################################################################

resource "aws_cloudtrail" "non_compliant_cloudtrail" {
  name                          = "${var.env_name}-${var.infra_type}-cloudtrail-${count.index + 1}"
  count                         = var.infra_type == "non-compliant" ? var.var_count : 0
  s3_bucket_name                = var.s3_bucket
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  is_multi_region_trail         = false
  enable_logging                = false
  enable_log_file_validation    = false

  tags = {
    Name                        = "${var.env_name}-${var.infra_type}-cloudtrail-${count.index + 1}"
  }
}
