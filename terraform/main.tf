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

# -----------------
# Backend S3 bucket
# -----------------

# -----------------
# ECR repository
# -----------------
resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# -----------------
# CloudWatch Log group, metric filter, alarm
# -----------------
resource "aws_cloudwatch_log_group" "eks_app_logs" {
  name              = "/eks/${var.cluster_name}/application"
  retention_in_days = 14

  tags = {
    Project = var.project_name
  }
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "flask-error-filter"
  log_group_name = aws_cloudwatch_log_group.eks_app_logs.name
  pattern        = "ERROR"

  metric_transformation {
    name      = "FlaskErrorCount"
    namespace = "HariApp"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "flask-error-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FlaskErrorCount"
  namespace           = "HariApp"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  alarm_description = "Triggered when Flask errors exceed threshold"
}

# -----------------
# RDS: VPC data, security group, subnet group and DB instance
# -----------------
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-notes-vpc"]
  }

  filter {
    name   = "tag:Project"
    values = ["flask-notes"]
  }

  filter {
    name   = "cidr-block"
    values = [var.vpc_cidr]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "cidr-block"
    values = [
      "10.0.101.0/24",
      "10.0.102.0/24"
    ]
  }
}

resource "aws_security_group" "rds" {
  name        = "hari-rds-sg"
  description = "Allow MySQL access from EKS VPC"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "hari-rds-sg"
    Project = var.project_name
    Owner   = "hariharan"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "hari-rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name    = "hari-rds-subnet-group"
    Project = var.project_name
    Owner   = "hariharan"
  }
}

resource "aws_db_instance" "mysql" {
  identifier = "hari-mysql"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Project = var.project_name
  }
}

# -----------------
# EKS via upstream module
# -----------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.0.101.0/24","10.0.102.0/24"]
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_service_ipv4_cidr = "172.20.0.0/16"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  tags = {
    Project = var.project_name
  }
}

module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  subnet_ids      = module.vpc.private_subnets

  name = "flask-notes-ng"

  instance_types = ["t3.small"]

  min_size     = 1
  max_size     = 2
  desired_size = 1
}
