terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "ami_id" {
  description = "ami id getting through datasource"
  value = data.aws_ami.name.id
}

resource "aws_instance" "my_server" {
  ami = data.aws_ami.name.id
  instance_type = "t3.micro"

  tags = {
    Name = "tokyo"
  }
}