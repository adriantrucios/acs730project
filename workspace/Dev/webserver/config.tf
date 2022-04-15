# S3 Bucket Dev webserver
terraform {
  backend "s3" {
    bucket = "group-10-acs-project"
    key    = "dev/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}