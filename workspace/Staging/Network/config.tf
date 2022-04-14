terraform {
  backend "s3" {
    bucket = "group-10-acs-project" 
    key    = "staging/network/terraform.tfstate"    
    region = "us-east-1"                        
  }
}