# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
}

# Name prefix
variable "prefix" {
  type        = string
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
}


# Variable to signal the current environment 
variable "env" {
  type        = string
}