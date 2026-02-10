resource "aws_db_subnet_group" "this" {
  name       = "hari-rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name    = "hari-rds-subnet-group"
    Project = "hari-project"
    Owner   = "hariharan"
  }
}
