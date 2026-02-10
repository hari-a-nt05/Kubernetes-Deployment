terraform {
  backend "s3" {
    bucket         = "hari-backend-terraform-state"
    key            = "ecr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hari-backend-terraform-locks"
    encrypt        = true
  }
}
