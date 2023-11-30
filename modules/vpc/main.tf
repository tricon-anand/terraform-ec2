//Create VPC 
resource "aws_vpc" "production_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

//Create public subnet 
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name="PublicSubnet"
  }
}

//create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name="PirvateSubnet"
  }
}

//create route-table for public subnet
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production_vpc.id
  
  tags = {
    Name="PublicRouteTable"
  }
}

//create route-table for private subnet
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name="PrivateRouteTable"
  }
}

//associate public subnet to route-table of public
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

//associate private subnet to route-table of private
resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}


//Create ELastic IP to Nat Gateway
resource "aws_eip" "elastic_ip_nat_gateway" {
  domain = "vpc"
  associate_with_private_ip = "10.0.0.5" 
  tags = {
    Name = "ElasticIP-Nat-Gateway"
  }
}

//assoicate nat gateway to elastic ip and public subnet
resource "aws_nat_gateway" "nat-gateway-to-eip" {
  subnet_id = aws_subnet.public-subnet.id
  allocation_id = aws_eip.elastic_ip_nat_gateway.id

  tags = {
    Name = "NatGateWaytoPubliceSubnet"
  }

  depends_on = [ aws_eip.elastic_ip_nat_gateway ]
}

//associate private route table to nat gateway which is connect to elastic ip
resource "aws_route" "nat-gateway-route-private-subnet-table" {
  route_table_id = aws_route_table.private-route-table.id
  nat_gateway_id = aws_nat_gateway.nat-gateway-to-eip.id
  destination_cidr_block = "0.0.0.0/0"
}

//create internet gateway for public
resource "aws_internet_gateway" "generate-interet-gateway" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

//associate public route table to internet gateway for public access
resource "aws_route" "interet-gateway-public-subnet" {
  route_table_id = aws_route_table.public-route-table.id
  gateway_id = aws_internet_gateway.generate-interet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}


//create Network ACL for VPC
resource "aws_network_acl" "vpc_newtwork_security_acl" {
  vpc_id = aws_vpc.production_vpc.id
  subnet_ids = [ aws_subnet.public-subnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "My VPC ACL"
}
}