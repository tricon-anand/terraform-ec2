module "my_vpc" {
  source                  = "../vpc"
  vpc_name                = "testVPC"
  cidr_block              = "10.0.0.0/16"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

resource "aws_instance" "simple_nodejs"{
  ami = var.ami
  instance_type = var.instance_type  
  tags = {
    Name = var.instance_names
  }
  subnet_id = module.my_vpc.output_subnet
  security_groups = [aws_security_group.TF_SG.name]
  user_data = file("${path.module}/script.sh")
}


resource "aws_security_group" "TF_SG" {
  name        = "Allow SSH, HTTP and HTTPS"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = module.my_vpc.output_aws_vpc

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test"
  }
}
