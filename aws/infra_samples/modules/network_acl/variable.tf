variable "env_name" {
  type      = string
  default   = "dev"
}

variable "var_count" {
  type      = number
  default   = 1
}

variable "region_name" {
  type      = string
  default   = "us-east-1"
}

variable "infra_type" {
  type      = string
  default   = "compliant"
}

variable "vpc_id" {
  default   = "aws_vpc.compliant_vpc[0].id"
}
variable "subnet_id" {
  default     = "aws_subnet.public[0].id"
}
variable "cidr" {
  default     = "10.0.0.0/16"
}