resource "aws_instance" "simple_nodejs"{
  ami = var.ami
  instance_type = var.instance_type  
  count = var.instances_count
  tags = {
    Name = var.instance_names[count.index]
  }
}
