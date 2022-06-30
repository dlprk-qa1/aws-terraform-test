output "out_iam_group_self_link" {
  description       = "iam group name"
  value             = aws_iam_group.iam_group_infra_sample[0].name
}