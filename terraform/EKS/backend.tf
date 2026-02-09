terraform {
  backend "s3" {
    bucket         = "hari-bucket"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-lock-table"
  }
}
