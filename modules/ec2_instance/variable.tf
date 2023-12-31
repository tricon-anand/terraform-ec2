variable "instance_type" {
    description = "Type of instances to create"
    type        = string
}

variable "ami" {
    description = "AMI ID for instances"
    type        = string
}

variable "aws_keypair" {
  type =  any
}

variable "instance_names" {
  description = "List of instance names"
  type = string
}

variable "publicSubnet" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}