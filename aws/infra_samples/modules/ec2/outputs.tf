output "out_ec2_self_link" {
  description       = "ec2 instanmce self link"
  value             = aws_instance.compliant_ec2_instance[0].id
}