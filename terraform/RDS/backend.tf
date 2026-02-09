terraform {
  backend "s3" {
    bucket         = "hari-bucket-terraform-state"
    key            = "rds/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hari-bucket-terraform-locks"
    encrypt        = true
  }
}
