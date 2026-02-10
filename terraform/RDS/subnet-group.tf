resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "rds-subnet-group"
  }
}
