# Terraform Project: Application Load Balancer + Auto Scaling Groups

## Project Title: Highly Available Web Application Using ALB + ASG on AWS (Terraform)

This project provisions a highly available, scalable, and load‑balanced web application architecture using Terraform, AWS Application Load Balancer (ALB), Launch Templates, Auto Scaling Groups (ASG), and CloudWatch Alarms.

**It deploys two different micro‑apps:**

  - / → Home Application

  - /cloth/ → Cloth Application

Each application has its own Launch Template, ASG, and Target Group. The ALB performs path‑based routing.
## Terraform main.tf

```hcl
provider "aws" {
  region = "us-east-1"
}

# ---------------- Launch Templates ----------------
resource "aws_launch_template" "lt-home" {
  name                   = "home"
  image_id               = "ami-0ecb62995f68bb549"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-09a08028b02863dc8"]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    echo "Hello, Home" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
EOF
  )

  tags = {
    Name = "home"
  }
}

resource "aws_launch_template" "lt-cloth" {
  name                   = "cloth"
  image_id               = "ami-0ecb62995f68bb549"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-09a08028b02863dc8"]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    mkdir -p /var/www/html/cloth
    echo "Hello, cloth" > /var/www/html/cloth/index.html
    systemctl start nginx
    systemctl enable nginx
EOF
  )

  tags = {
    Name = "cloth"
  }
}

# ---------------- Target Groups (with health checks) ----------------
resource "aws_lb_target_group" "home-tg" {
  name        = "home-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0c8f87c489844e32e"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }
}

resource "aws_lb_target_group" "cloth-tg" {
  name        = "cloth-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0c8f87c489844e32e"

  health_check {
    # /cloth/ serves index.html created by user-data
    path                = "/cloth/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }
}

# ---------------- Application Load Balancer ----------------
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-09a08028b02863dc8"]
  subnets = [
    "subnet-062f4a2fe317e3572",
    "subnet-0022322b5ca2dd58e",
    "subnet-0c9de33756c540f6c",
    "subnet-079207882cef10e8e"
  ]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home-tg.arn
  }
}

resource "aws_lb_listener_rule" "rule-cloth" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloth-tg.arn
  }

  condition {
    path_pattern {
      values = ["/cloth/*"]
    }
  }
}

# ---------------- Auto Scaling Groups ----------------
# Use AZs known to support t3.micro in your account (avoid us-east-1e)
resource "aws_autoscaling_group" "asg-home" {
  name                      = "asg-home"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.lt-home.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.home-tg.arn]

  tag {
    key                 = "Name"
    value               = "home"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg-cloth" {
  name                      = "asg-cloth"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.lt-cloth.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.cloth-tg.arn]

  tag {
    key                 = "Name"
    value               = "cloth"
    propagate_at_launch = true
  }
}

# ---------------- Scaling Policies & Alarms ----------------
resource "aws_autoscaling_policy" "home_scale_down" {
  name                   = "home-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg-home.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
  depends_on             = [aws_autoscaling_group.asg-home]
}

resource "aws_cloudwatch_metric_alarm" "home_scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.home_scale_down.arn]
  alarm_name          = "home-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 25
  evaluation_periods  = 5
  period              = 30
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-home.name
  }
}

resource "aws_autoscaling_policy" "cloth_scale_down" {
  name                   = "cloth-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg-cloth.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
  depends_on             = [aws_autoscaling_group.asg-cloth]
}

resource "aws_cloudwatch_metric_alarm" "cloth_scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.cloth_scale_down.arn]
  alarm_name          = "cloth-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 25
  evaluation_periods  = 5
  period              = 30
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg-cloth.name
  }
}
```
### Why This Project Is Important in Real‑World Tech?

**1. Scalability**

ASGs automatically add/remove EC2 instances based on load.

**2. High Availability**

Instances run across multiple AZs → no single point of failure.

**3. Load Balancing**

ALB distributes traffic intelligently based on URL paths.

**4. Cost Optimization**

Auto‑scale down when CPU ≤ 25% (CloudWatch alarm).

**5. Production‑grade Architecture**

Things that covered in this flow :
```
Launch Templates

Path-based routing

Health checks

Monitoring + Alarms

Autoscaling policies
```
This is the same architecture used in enterprise microservices & e‑commerce systems.

##  Full Architecture Flow 

```
                    ┌──────────────────────────┐
                    │      Internet Users      │
                    └──────────────┬───────────┘
                                   │
                         ┌─────────▼─────────┐
                         │  Application LB   │
                         └───────┬───────────┘
                 ┌───────────────┼─────────────────┐
                 │                                 │
     Path: "/"   │               Path: "/cloth/*"  │
 ┌──────────────▼───────┐    ┌───────────────────▼─────────┐
 │   Target Group: Home │    │ Target Group: Cloth         │
 └──────────────┬───────┘    └───────────────────┬─────────┘
                │                                │
       ┌────────▼────────┐             ┌─────────▼────────┐
       │ AutoScalingGrp  │             │ AutoScalingGrp   │
       │    (Home)       │             │     (Cloth)      │
       └────────┬────────┘             └─────────┬────────┘
                │                                │
        ┌───────▼──────┐                 ┌────────▼───────┐
        │ LaunchTemplate│                │ LaunchTemplate │
        │     Home      │                │     Cloth      │
        └───────────────┘                └────────────────┘

```
##  Detailed Explanation of Each Terraform Block

Below is a clear and complete explanation of how every block works.

**1️⃣ Provider Block**

Configures AWS provider.
```
provider "aws" {
  region = "us-east-1"
}
```
 Importance:

Terraform needs to know which cloud you are provisioning.

Without this, Terraform throws Invalid provider configuration.

---
**2️⃣ Launch Templates**

Launch Templates define:

 - AMI

 - Instance type

 - Security group

 - User data (Bootstrap Script)

####  Launch Template – Home App

Creates EC2 that serves Hello, Home via NGINX.

#### Launch Template – Cloth App

Creates EC2 that serves Hello, Cloth at /cloth/ path.

 Importance:

A template for Auto Scaling Groups.

Ensures consistent EC2 configuration.

User_data installs nginx + sets content.

---

**3️⃣ Target Groups (TG)**

Each TG maps traffic to EC2 instances.

 -  Home TG → serves /
 -  Cloth TG → serves /cloth/

Each TG includes health checks, ensuring:

Only healthy EC2 receive traffic.

ALB knows when to stop sending requests.

 Importance:

Required for ALB routing.

Enables auto healing with ASG.

---

**4️⃣ Application Load Balancer (ALB)**
```
resource "aws_lb" "alb" {...}
```
What ALB Does:

 - Entry point for all users.

 - Listens on port 80.

 - Performs path‑based routing.

 - Distributes traffic intelligently.

 Importance:

Adds load balancing.

Enhances performance and reliability.

Required for microservices URLs.

---
**5️⃣ Listener + Listener Rule**
  Listener

Receives incoming traffic on port 80. Default action → Home TG.

  Listener Rule

If URL contains /cloth/* → forward to Cloth TG.

 Importance:

Implements real world application routing.

Same concept used in e‑commerce:

 - /payments/*

 - /products/*

 - /cart/*

---

**6️⃣ Auto Scaling Groups (ASG)**

Each application has 1 ASG.

  ASG‑Home → Uses LT‑Home → Attaches to Home TG
  ASG‑Cloth → Uses LT‑Cloth → Attaches to Cloth TG
ASG Features:

Runs EC2 across 3 Availability Zones.

Ensures instance replacement.

Performs health checks using ALB.

 Importance:

Self‑healing architecture.

Scales automatically.

Ensures uptime even if instance fails.

---
**7️⃣ Scaling Policies + CloudWatch Alarms**

If CPU ≤ 25% for 5 evaluation periods → scale down by 1.

 Importance:

Saves cost.

Enables dynamic scaling.

Used in production.

