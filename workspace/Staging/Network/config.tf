terraform {
  backend "s3" {
    bucket = "group-10-acs-project-staging"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}
