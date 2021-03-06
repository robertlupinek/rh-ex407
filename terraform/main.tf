#WIP

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
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
    Name = var.project_name
    Terraform = "true"
    ProjectName = var.project_name
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "devops" {
  vpc_id = aws_vpc.devops.id
  tags = {
    Name = var.project_name
    Terraform = "true"
    ProjectName = var.project_name
  }
}

#Create the subnet for the project
resource "aws_subnet" "devops" {
  vpc_id = aws_vpc.devops.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.aws_region}${var.availability_zone}"
  tags = {
    Name = var.project_name
    Terraform = "true"
    ProjectName = var.project_name
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
    Name = "${var.project_name}-igw"
    Terraform = "true"
    ProjectName = var.project_name
  }
}

resource "aws_route_table_association" "devops" {
  subnet_id = aws_subnet.devops.id
  route_table_id = aws_route_table.devops_igw.id
}

## Security Groups
resource "aws_security_group" "jump_hosts" {
  name        = "${var.project_name}-jump-hosts"
  description = "Allow ssh from home to jump host"
  vpc_id      = aws_vpc.devops.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.to_jump_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-jump-hosts"
    Project = var.project_name
  }
}

resource "aws_security_group" "devops_hosts" {
  name        = "${var.project_name}-devops-hosts"
  description = "Allow ssh from Jump host to Devops hosts"
  vpc_id      = aws_vpc.devops.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.jump_hosts.id}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.jump_hosts.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-devops-hosts"
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "devops_hosts" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.devops_hosts.id
  security_group_id = aws_security_group.devops_hosts.id
}


## Elastic IP Addresses

resource "aws_eip" "jump_host" {
  instance = aws_instance.jump_host.id
  vpc      = true
}

## Create a few small EBS volume

resource "aws_ebs_volume" "ebs10g" {
  size              = 10
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.project_name}-10g"
    Project = var.project_name
  }
}

resource "aws_ebs_volume" "ebs1g" {
  size              = 1
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.project_name}-1g"
    Project = var.project_name
  }
}

resource "aws_volume_attachment" "ebs10g" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs10g.id
  instance_id = aws_instance.node1.id
}

resource "aws_volume_attachment" "ebs1g" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs1g.id
  instance_id = aws_instance.node4.id
}

## Jump host

resource "aws_instance" "jump_host" {
  ami           = var.default_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.jump_hosts.id}"]
  subnet_id = aws_subnet.devops.id
  private_ip = var.instance_ips["jumphost"]
  key_name = var.key_name
  iam_instance_profile = var.devops_kms_role
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-jump-host"
    Project = var.project_name
    instance-parker = "workdays"
  }
  user_data = templatefile("${path.module}/templates/jump_host_user_data.tmpl", { ssh_key = var.ssh_key, jump_host_private_ip = var.instance_ips["jumphost"], node1_private_ip = var.instance_ips["host1"], node2_private_ip = var.instance_ips["host2"], node3_private_ip = var.instance_ips["host3"], node4_private_ip = var.instance_ips["host4"] })
}

resource "aws_instance" "node1" {
  ami           = var.default_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.devops_hosts.id}"]
  subnet_id = aws_subnet.devops.id
  associate_public_ip_address = true
  private_ip = var.instance_ips["host1"]
  key_name = var.key_name
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-ansible-host-01"
    Project = var.project_name
    instance-parker = "workdays"
  }
  user_data = templatefile("${path.module}/templates/jump_host_user_data.tmpl", { ssh_key = var.ssh_key, jump_host_private_ip = var.instance_ips["jumphost"], node1_private_ip = var.instance_ips["host1"], node2_private_ip = var.instance_ips["host2"], node3_private_ip = var.instance_ips["host3"], node4_private_ip = var.instance_ips["host4"] })
}

resource "aws_instance" "node2" {
  ami           = var.default_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.devops_hosts.id}"]
  subnet_id = aws_subnet.devops.id
  associate_public_ip_address = true
  private_ip = var.instance_ips["host2"]
  key_name = var.key_name
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-ansible-host-02"
    Project = var.project_name
    instance-parker = "workdays"
  }
  user_data = templatefile("${path.module}/templates/jump_host_user_data.tmpl", { ssh_key = var.ssh_key, jump_host_private_ip = var.instance_ips["jumphost"], node1_private_ip = var.instance_ips["host1"], node2_private_ip = var.instance_ips["host2"], node3_private_ip = var.instance_ips["host3"], node4_private_ip = var.instance_ips["host4"] })
}

resource "aws_instance" "node3" {
  ami           = var.default_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.devops_hosts.id}"]
  subnet_id = aws_subnet.devops.id
  associate_public_ip_address = true
  private_ip = var.instance_ips["host3"]
  key_name = var.key_name
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-ansible-host-03"
    Project = var.project_name
    instance-parker = "workdays"
  }
  user_data = templatefile("${path.module}/templates/jump_host_user_data.tmpl", { ssh_key = var.ssh_key, jump_host_private_ip = var.instance_ips["jumphost"], node1_private_ip = var.instance_ips["host1"], node2_private_ip = var.instance_ips["host2"], node3_private_ip = var.instance_ips["host3"], node4_private_ip = var.instance_ips["host4"] })
}

resource "aws_instance" "node4" {
  ami           = var.default_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.devops_hosts.id}"]
  subnet_id = aws_subnet.devops.id
  associate_public_ip_address = true
  private_ip = var.instance_ips["host4"]
  key_name = var.key_name
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-ansible-host-04"
    Project = var.project_name
    instance-parker = "workdays"
  }
  user_data = templatefile("${path.module}/templates/jump_host_user_data.tmpl", { ssh_key = var.ssh_key, jump_host_private_ip = var.instance_ips["jumphost"], node1_private_ip = var.instance_ips["host1"], node2_private_ip = var.instance_ips["host2"], node3_private_ip = var.instance_ips["host3"], node4_private_ip = var.instance_ips["host4"] })
}
