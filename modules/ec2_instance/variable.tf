variable "instance_type" {
    description = "Type of instances to create"
    type        = string
}

variable "ami" {
    description = "AMI ID for instances"
    type        = string
}

# variable "instances_count" {
#    description = "Number of instance to create"
#    type = number
# }

variable "aws_keypair" {
  type =  any
}

variable "instance_names" {
  description = "List of instance names"
  type = string
}

variable "public_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}