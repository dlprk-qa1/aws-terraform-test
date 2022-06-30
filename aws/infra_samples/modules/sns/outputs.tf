output "out_snstopic_self_link" {
  description     = "sns topic arn"
  value           = aws_sns_topic.sns_topic[0].arn
}