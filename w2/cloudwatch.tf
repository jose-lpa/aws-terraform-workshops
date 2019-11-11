# Uncomment and specify resource arguments below according to documentation and workshop guide:
# https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name = "jose-alarm-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 40
  alarm_description = "This alarm triggers when CPU load in Autoscaling group is high."
  
  # Use autoscaling policy ARN as an alarm action here
  # Reference: http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  alarm_actions = [
    "${aws_autoscaling_policy.autoscale_group_policy_up_x1.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low_alarm" {
  alarm_name = "jose-alarm-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 35
  alarm_description = "This alarm triggers when CPU load in Autoscaling group is low."
  
  # Use autoscaling policy ARN as an alarm action here
  # Reference: http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  alarm_actions = [
    "${aws_autoscaling_policy.autoscale_group_policy_down_x1.arn}",
  ]
}
