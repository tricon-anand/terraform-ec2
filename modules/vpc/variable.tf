variable "vpc_name" {
  description = "Name for the VPC"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
}

variable "destinationCIDRblock" {
  type = string
}

variable "naclPortsPublic" {
  type = list(string)
  default = [ 22, 80 ]
}