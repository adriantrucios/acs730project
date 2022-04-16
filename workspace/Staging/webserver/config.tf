# S3 Bucket Dev webserver
terraform {
  backend "s3" {
    bucket = "acs730project-staging"
    key    = "prod/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}
