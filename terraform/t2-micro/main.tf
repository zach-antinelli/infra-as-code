variable "config" {
  # Infrastructure configuration settings
  type = any
  default = {
    "ami"             = "ami-06e85d4c3149db26a"
    "instance_type"   = "t2.micro"
    "region"          = "us-west-2"
    "security_groups" = ["mgmt", "web"]
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
  ami           = var.config["ami"]
  instance_type = var.config["instance_type"]
}