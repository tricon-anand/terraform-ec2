module "vpc" {
  source                  = "./modules/vpc"
  vpc_name                = "MyFirstVPC"
  cidr_block              = "10.0.0.0/16"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  instance_type = "t2.micro"
  ami="ami-0fc5d935ebf8bc3bc"
  instance_names = "dev"
  aws_keypair = module.key_pair.aws_keypair
  publicSubnet = module.my_vpc.ouput-public-subnet
  vpc_security_group_ids = [module.aws_security_group.sg_list]
}

module "key_pair" {
  source = "./modules/keypair"
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket = "tf-anand-state-bucket"
}

module "aws_security_group" {
  source = "./modules/security_group"
  vpc_id = module.mvpc.output_aws_vpc
}