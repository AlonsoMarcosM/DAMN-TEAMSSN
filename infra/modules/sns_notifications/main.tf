resource "aws_sns_topic" "alerts" {
  name = var.topic_name

  tags = merge(var.tags, {
    Name = var.topic_name
  })
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.admin_email
}
