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

variable "sns_subscription_email" {
  type        = string
  default     = "xxxxxxxx"
  description = "Email address to be set for creating compliant SNS Topic Subscription endpoint"
}