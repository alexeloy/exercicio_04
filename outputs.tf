output "launch_template_id" {
  value = aws_launch_template.lt.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}