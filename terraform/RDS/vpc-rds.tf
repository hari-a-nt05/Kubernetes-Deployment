data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-notes-vpc"]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.0.0/16"]
  }
}
