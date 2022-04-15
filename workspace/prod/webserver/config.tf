# S3 Bucket Prod webserver
terraform {
  backend "s3" {
    bucket = "group-10-acs-project"
    key    = "prod/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}