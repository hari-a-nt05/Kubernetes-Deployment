variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "hari-backend"
}

variable "ecr_repository_name" {
  type    = string
  default = "hari-repo"
}

variable "db_name" {
  type    = string
  default = "haridb"
}

variable "db_username" {
  type    = string
  default = "hariadmin"
}

variable "db_password" {
  type      = string
  default   = "hari2415"
  sensitive = true
}

variable "cluster_name" {
  type    = string
  default = "hari-eks"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
