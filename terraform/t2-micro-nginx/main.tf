variable "config" {
  # Infrastructure configuration settings
  type = any
  default = {
    "ami"           = "ami-06e85d4c3149db26a"
    "instance_type" = "t2.micro"
    "region"        = "us-west-2"
    "key_name"      = "ec2"
    "tags" = {
      "Name" = "web-server"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.config["region"]
}

resource "aws_security_group" "web_server" {
  name        = "web_server"
  description = "Allows HTTP/S and SSH traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "web_server" {
  ami                    = var.config["ami"]
  instance_type          = var.config["instance_type"]
  vpc_security_group_ids = [aws_security_group.web_server.id]
  tags                   = var.config["tags"]
  key_name               = var.config["key_name"]
  user_data              = <<-EOL
  #! /bin/sh
  sudo su - 
  useradd z -g wheel
  mkdir /home/z/.ssh
  cat /home/ec2-user/.ssh/authorized_keys sudo >> /home/z/.ssh/authorized_keys
  amazon-linux-extras enable nginx1 && yum clean metadata
  yum install -y nginx && systemctl enable --now nginx.service
  EOL
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.web_server.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.web_server.public_ip
}