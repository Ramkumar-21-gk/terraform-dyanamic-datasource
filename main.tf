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

# Data Source to get the most recent Amazon Linux AMI
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "ami_id" {
  description = "ami id getting through datasource"
  value = data.aws_ami.name.id
}

# Data Source to get VPC by tag Name
data "aws_vpc" "my-vpc" {
  tags = {
    Name = "my-vpc"
  }
}
output "vpc_id" {
  description = "aws vpc id"
  value = data.aws_vpc.my-vpc.id
}

# Data Source to get Security Group by tag Name
data "aws_security_group" "my-security-group" {
  tags = {
    Name = "nginx-sg"
  }
}
output "security_group_id" {
  description = "aws security group id"
  value = data.aws_security_group.my-security-group.id 
}

# Data Source to get all available availability zones
data "aws_availability_zones" "zones" {
  state = "available"
}

output "aws_zones" {
  description = "aws availability zones"
  value = data.aws_availability_zones.zones.names
}

# Data Source to get current region
data "aws_region" "my-region" {

}
output "current_region" {
  description = "current aws region"
  value = data.aws_region.my-region.region  
}

# Data Source to get caller identity
data "aws_caller_identity" "current" {
}

output "caller_info" {
  description = "value"
  value = data.aws_caller_identity.current
}

data "aws_security_group" "name" {
  tags = {
    Name = "nginx-sg"
  }
}

data "aws_subnet" "private-subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my-vpc.id]
  }
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_instance" "my_ec2" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  security_groups = [data.aws_security_group.name.id]
  subnet_id = data.aws_subnet.private-subnet.id
  tags = {
    Name = "my-ec2-instance"
  }
}