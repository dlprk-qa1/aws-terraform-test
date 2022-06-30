# KMS
module "kms" {
  source                    = "../modules/kms"
  count                     = contains(var.exclude_service, "kms") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "kms") || contains(var.service_type, "s3_bucket") || contains(var.service_type, "cloudtrail") || contains(var.service_type, "ebs") || contains(var.service_type, "rds") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0 : var.infra_type == "non-compliant" ? contains(var.service_type, "kms") || contains(var.service_type, "all") == true ? 1 : 0 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  region_name               = var.aws_region
}

# VPC
module "vpc" {
  source                    = "../modules/vpc"
  count                     = contains(var.exclude_service, "vpc") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "vpc") || contains(var.service_type, "ec2_instance") || contains(var.service_type, "security_group") || contains(var.service_type, "network_acl") ||contains(var.service_type, "all") == true ? 1 : 0 : var.infra_type == "non-compliant" ? contains(var.service_type, "vpc") || contains(var.service_type, "network_acl") || contains(var.service_type, "security_group") ||  contains(var.service_type, "all") == true ? 1 : 0 : 0
  env_name                  = var.env
  log_group_arn             = var.infra_type == "compliant" ? module.log_group[count.index].out_loggroup_self_link : ""
  infra_type                = var.infra_type
  region_name               = var.aws_region
}

# S3 Bucket
module "s3_bucket" {
  source                    = "../modules/s3"
  count                     = contains(var.exclude_service, "s3_bucket") == true ? 0 : contains(var.service_type, "s3_bucket") || contains(var.service_type, "cloudtrail") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  kms_key                   = var.infra_type == "compliant" ? module.kms[count.index].out_kms_self_link : ""
  infra_type                = var.infra_type
  region_name               = var.aws_region
}

# Security Group
module "security_group" {
  source                    = "../modules/security_group"
  count                     = contains(var.exclude_service, "security_group") == true ? 0 : contains(var.service_type, "security_group") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  vpc_id                    = var.infra_type == "compliant" ? module.vpc[count.index].out_vpc_self_link : ""
  infra_type                = var.infra_type
  region_name               = var.aws_region
}

# Log Group
module "log_group" {
  source                    = "../modules/loggroup"
  count                     = contains(var.exclude_service, "log_group") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "log_group") || contains(var.service_type, "vpc") || contains(var.service_type, "network_acl") || contains(var.service_type, "security_group") || contains(var.service_type, "cloudtrail") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0 : var.infra_type == "non-compliant" ? contains(var.service_type, "log_group") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  region_name               = var.aws_region
}

# EC2 Instance
module "ec2_instance" {
  source                    = "../modules/ec2"
  count                     = contains(var.exclude_service, "ec2_instance") == true ? 0 : contains(var.service_type, "ec2_instance") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  sg_id                     = var.infra_type == "compliant" ? module.security_group[count.index].out_sg_self_link : ""
  subnet_id                 = var.infra_type == "compliant" ? module.vpc[count.index].out_public_subnet_self_link : ""
  infra_type                = var.infra_type
  region_name               = var.aws_region
}
#cloudtrail
module "cloudtrail" {
  source                    = "../modules/cloudtrail"
  count                     = contains(var.exclude_service, "cloudtrail") == true ? 0 : contains(var.service_type, "cloudtrail") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  s3_bucket                 = module.s3_bucket[count.index].out_s3_self_link
  infra_type                = var.infra_type
  region_name               = var.aws_region
  log_group_arn             = var.infra_type == "compliant" ? module.log_group[count.index].out_loggroup_self_link : ""
  kms_key                   = var.infra_type == "compliant" ? module.kms[count.index].out_kms_self_link : "" 
}
#network_acl
module "network_acl" {
  source                    = "../modules/network_acl"
  count                     = contains(var.exclude_service, "network_acl") == true ? 0 : contains(var.service_type, "network_acl") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  region_name               = var.aws_region
  vpc_id                    = module.vpc[count.index].out_vpc_self_link 
  }

# SNS Topic
module "sns" {
  source                    = "../modules/sns"
  count                     = contains(var.exclude_service, "sns") == true ? 0 : contains(var.service_type, "sns") || contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  region_name               = var.aws_region
  sns_subscription_email    = var.infra_type == "compliant" ? var.sns_subscription_email : ""
}

# Cloudwatch alarm
module "cloudwatch_alarm" {
  source                    = "../modules/cloudwatch_alarm"
  count                     = contains(var.exclude_service, "cloudwatch_alarm") == true ? 0 : contains(var.service_type, "cloudwatch_alarm") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  region_name               = var.aws_region
  sns_topic_arn             = module.sns[count.index].out_snstopic_self_link
  log_group_name            = module.log_group[count.index].out_loggroup_self_link_2
}
  #rds
module "rds" {
  source                    = "../modules/rds"
  count                     = contains(var.exclude_service, "rds") == true ? 0 : contains(var.service_type, "rds") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  instance_class            = "db.m6g"
  infra_type                = var.infra_type
  region_name               = var.aws_region
  kms_key                   = var.infra_type == "compliant" ? module.kms[count.index].out_kms_self_link : ""
}

# IAM User
module "iam_user" {
  source                    = "../modules/iam_user"
  count                     = contains(var.exclude_service, "iam_user") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "iam_user") || contains(var.service_type, "iam_account") || contains(var.service_type, "all") == true ? 1 : 0 : var.infra_type == "non-compliant" ? contains(var.service_type, "iam_user") || contains(var.service_type, "all") == true ? 1 : 0 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  group_name                = var.infra_type == "compliant" ? module.iam_group[count.index].out_iam_group_self_link : ""
}

module "iam_group" {
  source                    = "../modules/iam_group"
  infra_type                = var.infra_type
  count                     = contains(var.exclude_service, "iam_user") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "iam_user") || contains(var.service_type, "iam_account") || contains(var.service_type, "all") == true ? 1 : 0 : 0
}

# IAM Account
module "iam_account" {
  source                    = "../modules/iam_account"
  count                     = contains(var.exclude_service, "iam_account") == true ? 0 : var.infra_type == "compliant" ? contains(var.service_type, "iam_account") || contains(var.service_type, "all") == true ? 1 : 0 : var.infra_type == "non-compliant" ? contains(var.service_type, "iam_account") || contains(var.service_type, "all") == true ? 1 : 0 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  user_arn                  = var.infra_type == "compliant" ? module.iam_user[count.index].out_iam_user_self_link : ""
}

module "ebs" {
  source                    = "../modules/ebs"
  count                     = contains(var.exclude_service, "ebs") == true ? 0 : contains(var.service_type, "ebs") || contains(var.service_type, "all") == true ? 1 : 0
  env_name                  = var.env
  infra_type                = var.infra_type
  kms_key                   = var.infra_type == "compliant" ? module.kms[count.index].out_kms_self_link : ""
  region_name               = var.aws_region
  }