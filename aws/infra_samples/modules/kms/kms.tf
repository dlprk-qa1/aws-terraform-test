##################################################### Common Resources ######################################################################
data "aws_caller_identity" "current" {}

locals {
    account_id          = data.aws_caller_identity.current.account_id
}

# Define KMS Policy
data "aws_iam_policy_document" "default" {
    count               = var.var_count
    version             = "2012-10-17"
    statement {
        sid    = "kmsiampolicy"
        effect = "Allow"
        principals {
            type        = "AWS"
            identifiers = ["arn:aws:iam::${local.account_id}:root"]
        }
        actions   = ["kms:*"]
        resources = ["*"]
    }
    statement {
        sid    = "kmspolicy"
        effect = "Allow"
        principals {
            type        = "Service"
            identifiers = ["cloudtrail.amazonaws.com","dynamodb.amazonaws.com","logs.${var.region_name}.amazonaws.com"]
        }
        actions   = ["kms:*"]
        resources = ["*"]
    }
}

##################################################### Compliant Resources ######################################################################

resource "aws_kms_key" "compliant_key" {
    count                   = var.infra_type == "compliant" ? var.var_count : 0
    description             = "Infra Sample Compliant Key"
    deletion_window_in_days = 10
    is_enabled              = true
    enable_key_rotation     = true
    policy                  = data.aws_iam_policy_document.default[count.index].json
}

resource "aws_kms_alias" "compliant_key_alias" {
    count                   = var.infra_type == "compliant" ? var.var_count : 0
    name                    = "alias/compliantkey${count.index + 1}"
    target_key_id           = aws_kms_key.compliant_key[count.index].key_id
}


####################################################### Non-Compliant Resources ################################################################

resource "aws_kms_key" "non_compliant_key" {
    count                   = var.infra_type == "non-compliant" ? var.var_count : 0
    description             = "Infra Sample Non-Compliant Key"
    deletion_window_in_days = 10
    is_enabled              = true
    policy                  = data.aws_iam_policy_document.default[count.index].json
}
