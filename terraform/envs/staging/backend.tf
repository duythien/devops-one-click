terraform {
  backend "s3" {    
    bucket = "thienterraform-state-bucket"
    key = "terraform/env/staging"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
  }
}