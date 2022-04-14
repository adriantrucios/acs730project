# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group10"
  }
  type        = map(any)
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Group10"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.250.0.0/16"
  type        = string
 
}

# Provision public subnets in Prod VPC
variable "public_subnet_cidrs" {
  default     = ["10.250.1.0/24", "10.250.2.0/24", "10.250.3.0/24"]
  type        = list(string)
}


# Provision private subnets in Prod VPC
variable "private_subnet_cidrs" {
  default     = ["10.250.4.0/24", "10.250.5.0/24", "10.250.6.0/24"]
  type        = list(string)
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
}