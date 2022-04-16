terraform {
  backend "s3" {
    bucket = "acs730project-dev"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}
