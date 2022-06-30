output "out_vpc_self_link" {
  description     = "vpc self link"
  value           = var.infra_type == "compliant" ? aws_vpc.compliant_vpc[0].id : aws_vpc.non_compliant_vpc[0].id
}

output "out_public_subnet_self_link" {
  description     = "public subnet self link"
  value           = var.infra_type == "compliant" ? aws_subnet.public[0].id : aws_subnet.public1[0].id
}