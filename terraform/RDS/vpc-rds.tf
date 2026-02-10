# Get VPC IDs matching name + CIDR
data "aws_vpcs" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-notes-vpc"]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.0.0/16"]
  }
}

# Convert to a single VPC
data "aws_vpc" "main" {
  id = one(data.aws_vpcs.main.ids)
}

# Get private subnets from that VPC
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
