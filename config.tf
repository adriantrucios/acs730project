terraform {
  backend "s3" {
    bucket = "group10-dev"                      // Bucket where to SAVE Terraform State
    key    = "dev-webservers/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}