##################################################### Common Resources ######################################################################

data "aws_caller_identity" "current" {}

locals {
  account_id                = data.aws_caller_identity.current.account_id
}

data "aws_ssm_parameter" "amazon_linux_ami" {  
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  name                      = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create a role
resource "aws_iam_role" "ec2_iam_role" {
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  name                      = "${var.env_name}-${var.infra_type}-instance-${count.index + 1}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ec2infrarole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  name                      = "${var.env_name}-${var.infra_type}-infrasample-instance-profile-${count.index + 1}"
  role                      = aws_iam_role.ec2_iam_role[count.index].name
}

##################################################### Compliant Resources ######################################################################


resource "aws_instance" "compliant_ec2_instance" {
  count                     = var.infra_type == "compliant" ? var.var_count : 0
  vpc_security_group_ids    = [var.sg_id]
  ami                       = data.aws_ssm_parameter.amazon_linux_ami[count.index].value
  instance_type             = "t2.micro"
  subnet_id                 = var.subnet_id
  iam_instance_profile      = aws_iam_instance_profile.ec2_profile[count.index].name
  associate_public_ip_address = true
  tags                      = {Name = "${var.env_name}-${var.infra_type}-instance-${count.index + 1}"}
}