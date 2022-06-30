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
variable "s3_bucket" {
  type        = string
}

variable "log_group_arn" {
  type        = string
}
variable "kms_key" {
  type = string
  default = "aws_kms_key.compliant_key[count.index].key_id"
}