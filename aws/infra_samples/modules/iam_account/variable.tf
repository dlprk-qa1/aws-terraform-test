variable "env_name" {
  type        = string
  default     = "dev"
}

variable "var_count" {
  type        = number
  default     = 1
}

variable "infra_type" {
  type        = string
  default     = "compliant"
}

variable "user_arn" {
  type        = string
}