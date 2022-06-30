##################################################### Common Resources ######################################################################

# Define IAM User Policy
data "aws_iam_policy_document" "iam_policy" {
  count      = var.var_count
  statement {
    actions       = ["ec2:Describe*"]
    effect        = "Allow"
    resources     = ["*"]
  }
}

##################################################### Compliant Resources ######################################################################

# Defined IAM User
resource "aws_iam_user" "compliant_iam_user" {
  count    = var.infra_type == "compliant" ? var.var_count : 0
  name     = "${var.env_name}-${var.infra_type}-iam-user-${count.index + 1}"
  path     = "/zs-infra/"

  tags     = {
    tag1   = "Infra-Sample-Deployment"
  }
}

resource "time_sleep" "wait_90_seconds" {
  depends_on  = [aws_iam_user.compliant_iam_user]
  create_duration = "90s"
}

resource "aws_iam_access_key" "compliant_iam_user_access_key" {
  count      = var.infra_type == "compliant" ? var.var_count : 0
  user       = aws_iam_user.compliant_iam_user[count.index].name
  depends_on = [time_sleep.wait_90_seconds]
}

resource "aws_iam_user_policy" "compliant_iam_user_policy" {
  count       = var.infra_type == "compliant" ? var.var_count : 0
  name        = "${var.env_name}-${var.infra_type}-iam-user-policy"
  user        = aws_iam_user.compliant_iam_user[count.index].name
  policy      = data.aws_iam_policy_document.iam_policy[count.index].json
}

resource "aws_iam_user_group_membership" "attach_compliant_iam_user_to_group" {
  count       = var.infra_type == "compliant" ? var.var_count : 0
  user        = aws_iam_user.compliant_iam_user[count.index].name
  groups      = [var.group_name]
}

##################################################### Non-Compliant Resources ######################################################################

# Defined IAM User
resource "aws_iam_user" "noncompliant_iam_user" {
  count    = var.infra_type == "non-compliant" ? var.var_count : 0
  name     = "${var.env_name}-${var.infra_type}-iam-user-${count.index + 1}"
  path     = "/zs-infra/"

  tags     = {
    tag1   = "Infra-Sample-Deployment"
  }
}

resource "aws_iam_access_key" "noncompliant_iam_user_access_key1" {
  count      = var.infra_type == "non-compliant" ? var.var_count : 0
  user       = aws_iam_user.noncompliant_iam_user[count.index].name
}

resource "aws_iam_access_key" "noncompliant_iam_user_access_key2" {
  count      = var.infra_type == "non-compliant" ? var.var_count : 0
  user       = aws_iam_user.noncompliant_iam_user[count.index].name
}

resource "aws_iam_user_policy" "noncompliant_iam_user_policy" {
  count       = var.infra_type == "non-compliant" ? var.var_count : 0
  name        = "${var.env_name}-${var.infra_type}-iam-user-policy"
  user        = aws_iam_user.noncompliant_iam_user[count.index].name
  policy      = data.aws_iam_policy_document.iam_policy[count.index].json
}