# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Aparna",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "group10"
  description = "Name prefix"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.200.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}
