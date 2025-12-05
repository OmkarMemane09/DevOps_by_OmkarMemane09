provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "securitygroup" {
  name        = "securitygroup"

  tags = {
    Name = "securitygroup"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"   
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.securitygroup.id]
  user data = base64encode(<<-EOF
              #!/bin/bash
              apt update -y
              sudo yum install -y Nginx
              echo "<h1>Welcome to Terraform</h1>" > /var/www/html/index.html
              sudo systemctl start nginx
              sudo systemctl enable nginx
              
   EOF
)
  tags = {
    Name = "terraform"
  }
}
output "instance_public_ip" {
  value = aws_instance.terraform.public_ip
}
