variable "vpc_id" {
  type = string
}

variable "sgPortsPublic" {
  type = list(string)
  default = [ 22, 80 ]
}