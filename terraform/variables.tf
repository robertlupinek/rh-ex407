#WIP



variable "aws_region" {
  type = string
  description = "AWS Region to deploy infrastructure"
  default = "us-east-2"
}

variable "project_name" {
  type = string
  description = "Project name to use for tags and resource names"
  default = "us-east-2"
}

variable "to_jump_cidr" {
  type = string
  description = "IP Address to allow access to you Jump host"
  default = "173.21.99.171"
}
