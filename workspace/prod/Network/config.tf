# S3 bucket 
terraform {
  backend "s3" {
    bucket = "acs730project-prod"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}
