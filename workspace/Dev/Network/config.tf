terraform {
  backend "s3" {
    bucket = "group-10-acs-project-dev"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}
