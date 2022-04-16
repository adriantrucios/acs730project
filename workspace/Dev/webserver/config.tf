# S3 Bucket Dev webserver
terraform {
  backend "s3" {
    bucket = "acs730project-dev"
    key    = "dev/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}
