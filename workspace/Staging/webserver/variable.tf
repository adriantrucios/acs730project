# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group10"
  }
}

# Prefix to identify resources
variable "prefix" {
  type    = string
  default = "Group10"
}


# Variable to signal the current environment 
variable "env" {
  default = "staging"
  type    = string
}

variable "ec2_count" {
  type    = number
  default = "3"
}

