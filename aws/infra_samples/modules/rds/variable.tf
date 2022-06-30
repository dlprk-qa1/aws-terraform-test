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

variable "kms_key" {
  type = string
  default = "aws_kms_key.compliant_key[count.index].key_idS"
}

variable "instance_class" {
  type = string
}

variable "username" {
  default = "user1"
}

variable "password" {
  default = "pass2022"
}

variable "allocated_storage" {
  default = 25
}
