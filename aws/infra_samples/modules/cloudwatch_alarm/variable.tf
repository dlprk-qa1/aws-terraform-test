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

variable "sns_topic_arn" {
  type        = string
}

variable "log_group_name" {
  type        = string
}