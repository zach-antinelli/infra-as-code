variable "config" {
  # Infrastructure configuration settings
  type = any
  default = {
    "ami"             = "ami-06e85d4c3149db26a"
    "instance_type"   = "t2.micro"
    "region"          = "us-west-2"
    "security_groups" = ["sg-0ae916d265255f73a", "sg-00a1b9c3dbec5ffc1"]
    "key_name"        = "ec2"
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

resource "aws_instance" "web_server" {
  ami                    = var.config["ami"]
  instance_type          = var.config["instance_type"]
  vpc_security_group_ids = var.config["security_groups"]
  tags                   = var.config["tags"]
  key_name               = var.config["key_name"]
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.web_server.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = aws_instance.web_server.public_ip
}