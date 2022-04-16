terraform {
  backend "s3" {
    bucket = "acs730project-staging"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}
