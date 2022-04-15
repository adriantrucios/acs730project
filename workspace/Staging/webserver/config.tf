# S3 Bucket Dev webserver
terraform {
  backend "s3" {
    bucket = "group-10-acs-project"
    key    = "prod/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}