terraform {
  backend "s3" {
    bucket = "group-10-acs-project"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}