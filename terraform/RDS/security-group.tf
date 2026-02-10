resource "aws_security_group" "rds" {
  name        = "hari-rds-sg"
  description = "Allow MySQL access from EKS VPC"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # EKS VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "hari-rds-sg"
    Project = "hari-project"
    Owner   = "hariharan"
  }
}
