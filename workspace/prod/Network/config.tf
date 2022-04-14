# S3 bucket 
terraform {
  backend "s3" {
    bucket = "group-10-acs-project" 
    key    = "prod/network/terraform.tfstate" 
    region = "us-east-1"                  
  }
}