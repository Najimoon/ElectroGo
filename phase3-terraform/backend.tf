terraform {
  backend "s3" {
    bucket         = "electrogo-terraform-state-698547139150"
    key            = "phase3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "electrogo-terraform-locks"
    encrypt        = true
  }
}