output "out_kms_self_link" {
  description     = "kms key self link"
  value           = aws_kms_key.compliant_key[0].arn
}