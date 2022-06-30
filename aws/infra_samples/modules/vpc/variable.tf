variable "env_name" {
  type        = string
  default     = "dev"
}

variable "var_count" {
  type        = number
  default     = 1
}

variable "region_name" {
  type        = string
  default     = "us-east-1"
}

variable "infra_type" {
  type        = string
  default     = "compliant"
}

variable "cidr" {
  default     = "10.0.0.0/16"
}

variable "log_group_arn" {
  default     = "aws_cloudwatch_log_group.compliant_log_group.arn"
}