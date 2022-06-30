#######################complaint resource###############################
#Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (RDP Port: 3389)
resource "aws_network_acl" "acl_rdp" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-acl1-${0 + 1}"
  vpc_id          = var.vpc_id
  }

resource "aws_network_acl_rule" "rule1" {
  count = var.infra_type == "compliant" ? 1 : 0
  network_acl_id = aws_network_acl.acl_rdp[0].id
  rule_number    = 200
  egress = false
  protocol       = "tcp"
  rule_action    = "deny"
  cidr_block     = var.cidr
  from_port      = 3389
  to_port        = 3389
  
}
########acl doesnt allow to connect from from anywhere on any port####
resource "aws_network_acl" "acl_all" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-acl1-${count.index + 1}"
  #description     = "do not allows all traffic any on port "
  vpc_id          = var.vpc_id
  }

resource "aws_network_acl_rule" "rule2" {
  count = var.infra_type == "compliant" ? 1 : 0
  network_acl_id = aws_network_acl.acl_all[0].id
  rule_number    = 200
  egress = false
  protocol       = "all"
  rule_action    = "deny"
  cidr_block     = var.cidr
  from_port      = 3389
  to_port        = 3389
  
}
########acl doesnt allow to connect from from anywhere on any port####
resource "aws_network_acl" "acl_all1" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-acl_all1-${0 + 1}"
  # description     = "do not allows all traffic from any port"
  vpc_id          = var.vpc_id
}
resource "aws_network_acl_rule" "rule3" {
  count = var.infra_type == "compliant" ? 1 : 0
  network_acl_id = aws_network_acl.acl_all1[0].id
  rule_number    = 200
  egress = false
  protocol       = "all"
  rule_action    = "deny"
  cidr_block     = var.cidr
  from_port      = 22
  to_port        = 22
  
}
#Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (SSH Port: 22)
resource "aws_network_acl" "acl_ssh" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-acl_ssh-${0 + 1}"
  # description     = "do not allows all traffic on SSH port 22"
  vpc_id          = var.vpc_id
}

resource "aws_network_acl_rule" "rule4" {
  count = var.infra_type == "compliant" ? 1 : 0
  network_acl_id = aws_network_acl.acl_ssh[0].id
  rule_number    = 200
  egress = false
  protocol       = "all"
  rule_action    = "deny"
  cidr_block     = var.cidr
  from_port      = 22
  to_port        = 22
  
}

#############################non-complaint##################################

#Ensure Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (RDP Port: 3389)
resource "aws_network_acl" "non_acl_rdp" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-non-acl_rdp-${0 + 1}"
  # description     = "do not allows all traffic on port 3389"
  vpc_id          = var.vpc_id
  }

resource "aws_network_acl_rule" "rule11" {
  count = var.infra_type == "non-compliant" ? 1 : 0
  network_acl_id = aws_network_acl.non_acl_rdp[0].id
  rule_number    = 200
  egress = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.cidr
  from_port      = 3389
  to_port        = 3389
  
}
#allow from any port##
resource "aws_network_acl" "non_acl_all" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-non_acl1-${0 + 1}"
  # description     = "do not allows all traffic on port 3389"
  vpc_id          = var.vpc_id
  }

resource "aws_network_acl_rule" "rule22" {
  count = var.infra_type == "non-compliant" ? 1 : 0
  network_acl_id = aws_network_acl.non_acl_all[0].id
  rule_number    = 200
  egress = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.cidr
  from_port      = 3389
  to_port        = 3389
  
}
#Ensure Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (SSH Port: 22)
resource "aws_network_acl" "non_acl_ssh" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-non-acl_ssh-${0 + 1}"
  # description     = "do not allows all traffic on SSH port 22"
  vpc_id          = var.vpc_id
}

resource "aws_network_acl_rule" "rule33" {
  count = var.infra_type == "non-compliant" ? 1 : 0
  network_acl_id = aws_network_acl.non_acl_ssh[0].id
  rule_number    = 200
  egress = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.cidr
  from_port      = 22
  to_port        = 22
  
}
#allow from any port#
resource "aws_network_acl" "non_acl_all1" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  # name            = "${var.env_name}-${var.infra_type}-non_acl_all1-${0 + 1}"
  # description     = "do not allows all traffic from any port"
  vpc_id          = var.vpc_id
}

resource "aws_network_acl_rule" "rule44" {
  count = var.infra_type == "non-compliant" ? 1 : 0
  network_acl_id = aws_network_acl.non_acl_all1[0].id
  rule_number    = 200
  egress = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.cidr
  from_port      = 22
  to_port        = 22
  
}
