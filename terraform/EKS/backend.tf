terraform {
  backend "s3" {
    bucket         = "hari-bucket-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hari-terraform-lock"
  }
}
