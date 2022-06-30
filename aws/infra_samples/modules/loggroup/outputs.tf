output "out_loggroup_self_link" {
  description     = "log group arn"
  value           = aws_cloudwatch_log_group.log_group[0].arn
}

output "out_loggroup_self_link_2" {
  description     = "log group name"
  value           = aws_cloudwatch_log_group.log_group[0].name
}