resource "aws_cloudwatch_log_group" "eks_app_logs" {
  name              = "/eks/hari-eks/application"
  retention_in_days = 14

  tags = {
    Project = "hari-devops"
  }
}
