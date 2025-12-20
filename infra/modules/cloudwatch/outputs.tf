output "status_alarm_name" {
  value = aws_cloudwatch_metric_alarm.status_check_failed.alarm_name
}

output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}
