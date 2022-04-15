# Default tags
variable "default_tag" {
  default = {
    "Owner" = "Group10"
  }
}

variable "prefix" {
  type    = string
  default = "Group10"
}

variable "vpc_cidr" {
  default = "10.200.0.0/16"
  type    = string
}

# Provision public subnets in Staging VPC
variable "public_cidr_blocks" {
  default = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  type    = list(string)
}


# Provision private subnets in Staging VPC
variable "private_cidr_blocks" {
  default = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"]
  type    = list(string)
}

# Variable to signal the current environment 
variable "env" {
  default = "staging"
  type    = string
}