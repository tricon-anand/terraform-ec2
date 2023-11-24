variable "aws_security_group" {
  description = "Allow SSH and HTTP inbound traffic"
  type = object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(number) 
  })
}