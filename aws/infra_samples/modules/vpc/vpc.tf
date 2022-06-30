##################################################### Compliant Resource ######################################################################

resource "aws_vpc" "compliant_vpc" {
  count                            = var.infra_type == "compliant" ? var.var_count : 0
  cidr_block                       = var.cidr
  instance_tenancy                 = "default"

  tags = merge(
    { "Name" = "${var.env_name}-${var.infra_type}-vpc-${count.index + 1}" }
  )
}

resource "aws_internet_gateway" "infra_igw" {
  count                           = var.infra_type == "compliant" ? var.var_count : 0
  vpc_id                          = aws_vpc.compliant_vpc[count.index].id

  tags = merge(
    { "Name" = "${var.env_name}-${var.infra_type}-igw-${count.index + 1}" }
  )
}

resource "aws_subnet" "public" {
  count                         = var.infra_type == "compliant" ? var.var_count : 0
  vpc_id                        = aws_vpc.compliant_vpc[count.index].id
  cidr_block                    = "10.0.0.0/24"
  availability_zone             = "${var.region_name}c"
  map_public_ip_on_launch       = true

  tags = merge(
    {
      "Name" = "${var.env_name}-${var.infra_type}-public-subnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private" {
  count                       = var.infra_type == "compliant" ? var.var_count : 0
  vpc_id                      = aws_vpc.compliant_vpc[count.index].id
  cidr_block                  = "10.0.1.0/24"
  availability_zone           = "${var.region_name}b"

  tags = merge(
    {
      "Name" = "${var.env_name}-${var.infra_type}-private-subnet-${count.index + 1}"
    }
  )
}

resource "aws_flow_log" "compliant_vpc_flow_log" {
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  iam_role_arn              = aws_iam_role.compliant_iam_role_flowlog[count.index].arn
  log_destination           = var.log_group_arn
  traffic_type              = "ALL"
  vpc_id                    = aws_vpc.compliant_vpc[count.index].id
}

resource "aws_iam_role" "compliant_iam_role_flowlog" {
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  name                      = "${var.env_name}-${var.infra_type}-infrasample-flowlog-${count.index + 1}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "compliant_iam_policy_flowlog" {
  count                   = var.infra_type == "compliant" ? var.var_count : 0
  name                    = "${var.env_name}-${var.infra_type}-infrasample-flowlog-${count.index + 1}"
  role                    = aws_iam_role.compliant_iam_role_flowlog[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#Route Table for VPC allow traffic from specific range of IP address like /32
resource "aws_route_table" "route_tab" {
  count  = var.infra_type == "compliant" ? var.var_count : 0
  vpc_id = aws_vpc.compliant_vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/32"
    gateway_id = aws_internet_gateway.infra_igw[0].id
  }

  tags = {
    Name = "route_tab"
   }
 }
########non-complaint#########
resource "aws_vpc" "non_compliant_vpc" {
  count                            = var.infra_type == "non-compliant" ? var.var_count : 0
  cidr_block                       = var.cidr
  instance_tenancy                 = "default"

  tags = merge(
    { "Name" = "${var.env_name}-${var.infra_type}-vpc-${count.index + 1}" }
  )
}
resource "aws_internet_gateway" "infra_igw_non_compliant" {
  count                           = var.infra_type == "non-compliant" ? var.var_count : 0
  vpc_id                          = aws_vpc.non_compliant_vpc[count.index].id

  tags = merge(
    { "Name" = "${var.env_name}-${var.infra_type}-igw-${count.index + 1}" }
  )
}
resource "aws_subnet" "public1" {
  count                         = var.infra_type == "non-compliant" ? var.var_count : 0
  vpc_id                        = aws_vpc.non_compliant_vpc[count.index].id
  cidr_block                    = "10.0.0.0/24"
  availability_zone             = "${var.region_name}c"
  map_public_ip_on_launch       = true

  tags = merge(
    {
      "Name" = "${var.env_name}-${var.infra_type}-public-subnet-${count.index + 1}"
    }
  )
}
#Default SG for VPC allows traffic from 0.0.0.0/0
 resource "aws_default_security_group" "default" {
   count        = var.infra_type == "non-compliant" ? var.var_count : 0
   vpc_id       = aws_vpc.non_compliant_vpc[count.index].id
   ingress {
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
   }
 }
 
 #Route Table for VPC allow traffic from wide range of IP address like /16, /24 etc
 resource "aws_route_table" "route_tab_non_compliant" {
  count  = var.infra_type == "non-compliant" ? var.var_count : 0
  vpc_id = aws_vpc.non_compliant_vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.infra_igw_non_compliant[0].id
  }
  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.infra_igw_non_compliant[0].id
  }

  tags = {
    Name = "route_tab"
   }
 }
