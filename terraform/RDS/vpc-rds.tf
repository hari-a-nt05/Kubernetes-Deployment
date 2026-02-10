# Fetch EXACT VPC (must be unique)
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
    values = ["10.0.0.0/16"]
  }
}

# Fetch private subnets from that VPC
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
