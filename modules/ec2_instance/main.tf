resource "aws_instance" "first_ec2"{
  ami = var.ami
  instance_type = var.instance_type  
  tags = {
    Name = var.instance_names
  }
  subnet_id = var.publicSubnet
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data = file("${path.module}/script.sh")
  key_name = var.aws_keypair

  depends_on = [ var.aws_keypair ]
}