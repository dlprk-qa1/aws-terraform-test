##################################################### Compliant Resource ######################################################################

resource "aws_security_group" "compliant_sg" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  name            = "${var.env_name}-${var.infra_type}-sg-${count.index + 1}"
  description     = "allow inbound traffic to infra sample"
  vpc_id          = var.vpc_id

  ingress {
    description   = "from my ip range"
    from_port     = "3389"
    to_port       = "3389"
    protocol      = "tcp"
    cidr_blocks   = ["192.168.1.0/24"]
  }
  egress {
    cidr_blocks   = ["0.0.0.0/0"]
    from_port     = "0"
    protocol      = "-1"
    to_port       = "0"
  }
  tags = {
    "Name"        = "${var.env_name}-${var.infra_type}-sg-${count.index + 1}"
  }
}
#non-complaint#
#SG  allows inbound traffic from anywhere on SSH port#
resource "aws_security_group" "sg_ssh" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  name            = "${var.env_name}-${var.infra_type}-sg_ssh-${count.index + 1}"
  vpc_id          = var.vpc_id
  ingress {
    cidr_blocks = [
     "10.0.0.1/32"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "all"
  }
}
#SG  allows inbound traffic from anywhere on any port#
resource "aws_security_group" "sg_any1" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  name            = "${var.env_name}-${var.infra_type}-sg_any1-${count.index + 1}"
  vpc_id          = var.vpc_id
  ingress {
    cidr_blocks = [
     "10.0.0.1/32"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}
#SG  allows inbound traffic from anywhere on RDP:port 3389 port#
resource "aws_security_group" "sg_rdp" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  name            = "${var.env_name}-${var.infra_type}-sg_rdp-${count.index + 1}"
  description     = " allows all traffic on Port 3389"
  vpc_id          = var.vpc_id
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "all"
    cidr_blocks = [
     "10.0.0.1/32"
    ]
  }  
}
#SG  allows inbound traffic from anywhere on any port#
resource "aws_security_group" "sg_any" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  name            = "${var.env_name}-${var.infra_type}-sg_any-${count.index + 1}"
  description     = "do not allows all traffic on Port 3389"
  vpc_id          = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
     "10.0.0.1/32"
    ]
  }  
}
# #Ensure the default security group of every VPC restricts all traffic
# resource "aws_default_security_group" "sg_all_trafic" {
#   count  = var.infra_type == "compliant" ? var.var_count : 0
#   name   = "${var.env_name}-${var.infra_type}-sg_all_trafic-${count.index + 1}"
#   vpc_id = var.vpc_id
# }
# #Ensure every Security Group rule has a description
# resource "aws_security_group" "sg_rule" {
#   count       = var.infra_type == "compliant" ? var.var_count : 0
#   name        = "${var.env_name}-${var.infra_type}-sg_rule-${count.index + 1}"
#   description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
#   vpc_id      = var.vpc
#   ingress {
#     cidr_blocks = ["10.0.0.0/16"]
#     description = "What does this rule enable"
#     from_port   = 80
#     protocol    = "tcp"
#     to_port     = 80
#   }
# }



