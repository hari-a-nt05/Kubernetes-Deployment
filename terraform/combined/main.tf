terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "../ECR"

  aws_region           = var.aws_region
  ecr_repository_name  = var.ecr_repository_name
}

module "log" {
  source = "../LOG"
}

module "rds" {
  source = "../RDS"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "eks" {
  source = "../EKS"

  region       = var.aws_region
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
}
