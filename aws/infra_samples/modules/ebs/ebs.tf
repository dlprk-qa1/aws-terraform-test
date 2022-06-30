#############  Complaint  ###############################################
/*resource "aws_ebs_volume" "compilant-ebs" {
  count             = var.infra_type == "compliant" ? var.var_count : 0  
  availability_zone = "${var.region_name}a"
  size              = 40
  kms_key_id        = var.kms_key
  encrypted         = true

  tags = {
    Name = "${var.infra_type}-ebs"
  }
}*/

resource "aws_ebs_encryption_by_default" "compliant-ebs" {
  count             = var.infra_type == "compliant" ? var.var_count : 0  
  enabled = true
}

########################## Non-Compliant ##############################

/*resource "aws_ebs_volume" "noncompliant-ebs" { 
  count             = var.infra_type == "non-compliant" ? var.var_count : 0 
  availability_zone = "${var.region_name}a"
  size              = 40
  encrypted         = false

  tags = {
    Name = "${var.infra_type}-ebs-test"
  }
}*/

resource "aws_ebs_encryption_by_default" "noncompliant-ebs" {
  count             = var.infra_type == "non-compliant" ? var.var_count : 0 
  enabled = false
}