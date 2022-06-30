##################################################### Common Resource ######################################################################

resource "random_string" "random" {
  length        = 6
  special       = false
  number        = true
  upper         = false
  lower         = true
}

resource "aws_sns_topic" "sns_topic" {
  count         = var.var_count
  name          = "${var.env_name}-${var.infra_type}-snstopic-${count.index + 1}"

  tags = {
    Name        = "${var.env_name}-${var.infra_type}-snstopic-${count.index + 1}"
  }
}

##################################################### Compliant Resource ######################################################################

# After the sns topic subscription is created, click on link in received Email message for confirmation.
resource "aws_sns_topic_subscription" "compliant_sns_topic_subscription" {
  count         = var.infra_type == "compliant" ? var.var_count : 0
  topic_arn     = aws_sns_topic.sns_topic[count.index].arn
  protocol      = "email"
  endpoint      = var.sns_subscription_email
}

##################################################### Non-Compliant Resource ##################################################################

# sns topic subscription created with random generated email. It will be in unconfirmed state.
# After three days, Amazon SNS deletes the unconfirmed subscription automatically.
resource "aws_sns_topic_subscription" "non_compliant_sns_topic_subscription" {
  count         = var.infra_type == "non-compliant" ? var.var_count : 0
  topic_arn     = aws_sns_topic.sns_topic[count.index].arn
  protocol      = "email"
  endpoint      = "${random_string.random.result}@zscaler.com"
}