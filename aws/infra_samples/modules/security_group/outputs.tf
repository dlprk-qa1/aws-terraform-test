output "out_sg_self_link" {
  description     = "security group self link"
  value           = var.infra_type == "compliant" ? aws_security_group.compliant_sg[0].id : ""
}