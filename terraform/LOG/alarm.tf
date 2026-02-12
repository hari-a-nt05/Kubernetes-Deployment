resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "flask-error-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FlaskErrorCount"
  namespace           = "HariApp"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  alarm_description = "Triggered when Flask errors exceed threshold"
}
