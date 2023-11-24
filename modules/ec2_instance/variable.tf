variable "instance_type" {
    description = "Type of instances to create"
    type        = string
}

variable "ami" {
    description = "AMI ID for instances"
    type        = string
}

variable "instances_count" {
   description = "Number of instance to create"
   type = number
}

variable "instance_names" {
  description = "List of instance names"
  type = list(string)
}
