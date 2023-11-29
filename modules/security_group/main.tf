resource "aws_security_group" "TF_SG" {
  name        = "sg_instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = sgPortsPublic
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ] // Change to my local IP address if new to access from my ip address
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}