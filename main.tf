provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  #profile = "clearsale"
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "example-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = [var.subnet_id]
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
  metric_aggregation_type = "Average"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
  metric_aggregation_type = "Average"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "high_cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors high CPU utilization"
  dimensions                = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_up.arn]
  ok_actions                = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name                = "low_cpu"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"
  alarm_description         = "This metric monitors low CPU utilization"
  dimensions                = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_down.arn]
  ok_actions                = [aws_autoscaling_policy.scale_up.arn]
}