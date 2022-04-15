
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
  default = "10.100.0.0/16"
  type    = string

}

# Provision public subnets in Dev VPC
variable "public_cidr_blocks" {
  default = ["10.100.1.0/24", "10.100.2.0/24"]
  type    = list(string)
}


# Provision private subnets in Dev VPC
variable "private_cidr_blocks" {
  default = ["10.100.3.0/24", "10.100.4.0/24"]
  type    = list(string)

}

# Variable to signal the current environment 
variable "env" {
  default = "dev"
  type    = string
}