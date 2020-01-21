#WIP



variable "aws_region" {
  type = string
  description = "AWS Region to deploy infrastructure"
  default = "us-east-2"
}

variable "availability_zone" {
  type = string
  description = "AWS AZ to deploy infrastructure"
  default = "a"
}



variable "project_name" {
  type = string
  description = "Project name to use for tags and resource names"
  default = "devops"
}

variable "to_jump_cidr" {
  type = string
  description = "IP Address to allow access to you Jump host"
  default = "x.x.x.x/32"
}
