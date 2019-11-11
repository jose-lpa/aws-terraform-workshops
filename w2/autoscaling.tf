# Specify missing arguments according to documentation:
# https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
resource "aws_launch_configuration" "jose_configuration" {
  security_groups = ["${aws_security_group.w2_security_group.id}"]
  user_data = "${file("../shared/user-data.txt")}"

  # Keep below arguments 
  lifecycle { create_before_destroy = true }
  instance_type = "t2.micro"
  image_id = "ami-cb2305a1"
  enable_monitoring = true
}

# Specify missing arguments according to documentation:
# https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
resource "aws_autoscaling_group" "jose_autoscaling_group" {
  name = "w2-asg"
  min_size = 1
  max_size = 3
  launch_configuration = "${aws_launch_configuration.jose_configuration.name}"
  default_cooldown = 60

  # Keep below arguments
  availability_zones = [ "${var.availability_zone_id}" ]
  vpc_zone_identifier = [ "${var.subnet_id}" ]

  tag {
    key = "Name"
    value = "soa-workshop2"
    propagate_at_launch = true
  }

  lifecycle { create_before_destroy = true }
}

# Uncomment and specify arguments according to documentation and workshop guide:
# https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html
resource "aws_autoscaling_policy" "autoscale_group_policy_up_x1" {
  name = "autoscale_group_policy_up_x1"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = "${aws_autoscaling_group.jose_autoscaling_group.name}"
}

resource "aws_autoscaling_policy" "autoscale_group_policy_down_x1" {
  name = "autoscale_group_policy_down_x1"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = "${aws_autoscaling_group.jose_autoscaling_group.name}"
}
