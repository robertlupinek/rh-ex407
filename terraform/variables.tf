#WIP

variable "aws_region" {
  type = string
  description = "AWS Region to deploy infrastructure"
  default = "us-east-1"
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

variable "key_name" {
  type = string
  description = "Name of the key pair you want assigned to instances."
  default = "devops"
}

variable "default_ami" {
  type = string
  description = "Default AMI to deploy."
  default = "ami-02eac2c0129f6376b"
}

#This is overridden in the CI secrets
variable "to_jump_cidr" {
  type = string
  description = "IP Address to allow access to you Jump host"
  default = "x.x.x.x"
}

variable "devops_kms_role" {
  type = string
  description = "Instance Role that has access to the KMS key for secrets."
  default = "devops-kms"
}

variable "ssh_key" {
  type = string
  description = "SSH for logging into hosts"
  default = ""
}

variable "instance_ips" {
  type = map
  description = "Map of private IP Addresses to statically assign to hosts"
  default = {
    jumphost = "10.0.0.5",
    host1 = "10.0.0.80",
    host2 = "10.0.0.232",
    host3 = "10.0.0.233",
    host4 = "10.0.0.234"
  }

}
