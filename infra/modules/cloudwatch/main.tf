resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "${var.instance_id}-status-check-failed"
  alarm_description   = "EC2 status check failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.instance_id}-cpu-high"
  alarm_description   = "High CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]

  tags = var.tags
}
