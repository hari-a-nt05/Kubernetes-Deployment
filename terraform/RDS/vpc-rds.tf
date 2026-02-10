# Get VPC IDs (must match exactly one)
data "aws_vpcs" "main" {
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

# Convert to single VPC (safe now)
data "aws_vpc" "main" {
  id = one(data.aws_vpcs.main.ids)
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
