 module "ec2_instance" {
  source = "./modules/ec2_instance"
  instance_type = "t2.micro"
  ami="ami-0fc5d935ebf8bc3bc"
  instance_names = "dev"
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket = "tf-anand-state-bucket"
}

