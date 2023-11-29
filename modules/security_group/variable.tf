variable "vpc_id" {
  type = string
}

variable "sgPortsPublic" {
  type = list(string)
  default = [ 20, 80 ]
}