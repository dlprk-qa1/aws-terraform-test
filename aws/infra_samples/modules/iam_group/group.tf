resource "aws_iam_group" "iam_group_infra_sample" {
  count      = var.infra_type == "compliant" ? var.var_count : 0
  name       = "zs-infra-sample-iam-group"
  path       = "/zs-infra/"
}