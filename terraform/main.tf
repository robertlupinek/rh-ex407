#WIP

provider "aws" {
  version = "~> 2.0"
  region  = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "xxxxxxxxxxx"
    key = "xxxxxxxxxxx"
    region = "us-east-2"
  }
}

## VPC Settings

# Create a VPC
resource "aws_vpc" "devops" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "{$var.project_name}"
    Terraform = "true"
    ProjectName = "{$var.project_name}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "devops" {
  vpc_id = aws_vpc.devops.id
  tags = {
    Name = "{$var.project_name}"
    Terraform = "true"
    ProjectName = "{$var.project_name}"
  }
}


#Create the subnet for the project

resource "aws_subnet" "devops" {
  vpc_id = aws_vpc.devops.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.aws_region}${var.availability_zone}"
  tags = {
    Name = "{$var.project_name}"
    Terraform = "true"
    ProjectName = "{$var.project_name}"
  }
}

## Route tables and associations

resource "aws_route_table" "devops_igw" {
  vpc_id = aws_vpc.devops.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops.id
  }
  tags = {
    Name = "{$var.project_name}-igw"
    Terraform = "true"
    ProjectName = "{$var.project_name}"
  }
}

resource "aws_route_table_association" "devops" {
  subnet_id = aws_subnet.devops.id
  route_table_id = aws_route_table.devops_igw.id
}



## Security Groups

resource "aws_security_group" "jump_host" {
  name        = "Jump Host"
  description = "Allow ssh from home to jump host"
  vpc_id      = aws_vpc.devops.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.to_jump_cidr}"]
  }
}

## Jump host
