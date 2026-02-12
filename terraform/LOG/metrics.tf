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
