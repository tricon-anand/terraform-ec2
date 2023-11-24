module "ec2_instance" {
  source = "./modules/ec2_instance"
  instance_type = "t2.micro"
  ami="ami-0fc5d935ebf8bc3bc"
  key_name="testKeyPair"
  instances_count=3
  instance_names = ["dev", "uat", "prod"]
}