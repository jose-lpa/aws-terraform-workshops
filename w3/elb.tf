# Add missing arguments according to terraform/aws documentation.
# Docs: https://www.terraform.io/docs/providers/aws/r/elb.html
resource "aws_elb" "jose" {
  name = "jose-elb"
  security_groups = [ "${aws_security_group.w3-security-group.id}" ]
  connection_draining = true

  listener {
    # Add configuration of ELB listener here
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  # Configure ELB health checks here
  health_check {
    target = "HTTP:80/"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 2
    interval = 5
  }

  # Keep these arguments as is:
  subnets = [ "${var.subnet_id}" ]
  internal = false  # Will set the ELB to "internal" or "internet-facing".
}
