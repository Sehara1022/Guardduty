terraform {
  backend "s3" {
    bucket  = "guardduty-statefile-bucket"
    key     = "guardduty/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}