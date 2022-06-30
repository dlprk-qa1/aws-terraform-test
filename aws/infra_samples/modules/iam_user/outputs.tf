output "out_iam_user_self_link" {
  description       = "iam user arn"
  value             = aws_iam_user.compliant_iam_user[0].arn
}