provider "aws" {
  region = "ap-south-1"
}
# ----------------------------------------
# Existing VPC
# ----------------------------------------
data "aws_vpc" "selected" {
  id = "vpc-0680fed0370fe253f"
}

# ----------------------------------------
# Subnets
# ----------------------------------------
data "aws_subnet" "subnet1" {
  id = "subnet-00582d504b5c8eefd"
}

data "aws_subnet" "subnet2" {
  id = "subnet-0087567752e9c3529"
}

# ----------------------------------------
# Security Group
# ----------------------------------------
data "aws_security_group" "default_sg" {
  id = "sg-0b08dea20d58dddc7"
}

# ----------------------------------------
# Load Balancer Security Group
# ----------------------------------------
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}

# ----------------------------------------
# Application Load Balancer
# ----------------------------------------
resource "aws_lb" "app_lb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id
  ]
}

# ----------------------------------------
# Target Group
# ----------------------------------------
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id
}

# ----------------------------------------
# Listener (Routes ALB → Target Group)
# ----------------------------------------
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ----------------------------------------
# Launch Template (EC2 Configuration)
# ----------------------------------------
resource "aws_launch_template" "lt" {
  name_prefix   = "my-launch-template"
  image_id      = "ami-00d8fc944fb171e29"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.default_sg.id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 16
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Terraform-ASG-Instance"
    }
  }
}

# ----------------------------------------
# Auto Scaling Group
# ----------------------------------------
resource "aws_autoscaling_group" "asg" {
  name                = "my-asg"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id
  ]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "Terraform-ASG-Instance"
    propagate_at_launch = true
  }
}
output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

