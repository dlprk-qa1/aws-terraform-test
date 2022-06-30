variable "project_name" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_session_token" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "infra_type" {}

variable "service_type" {
  type = list(string)
}

variable "exclude_service" {
  type = list(string)
}

variable "sns_subscription_email" {
  type        = string
  default     = "xxxxxxxx"
  description = "Email address to be set for creating compliant SNS Topic Subscription endpoint"
}