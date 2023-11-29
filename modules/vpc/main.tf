resource "aws_vpc" "production_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name="PublicSubnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name="PirvateSubnet"
  }
}


resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production_vpc.id
  
  tags = {
    Name="PublicRouteTable"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name="PrivateRouteTable"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_eip" "elastic_ip_nat_gateway" {
  domain = "vpc"
  associate_with_private_ip = "10.0.0.5" 
  tags = {
    Name = "ElasticIP-Nat-Gateway"
  }
}

resource "aws_nat_gateway" "nat-gateway-to-eip" {
  subnet_id = aws_subnet.public-subnet.id
  allocation_id = aws_eip.elastic_ip_nat_gateway.id

  tags = {
    Name = "PrivateNatGateWaytoPubliceSubnet"
  }

  depends_on = [ aws_eip.elastic_ip_nat_gateway ]
}

resource "aws_route" "nat-gateway-route-private-subnet-table" {
  route_table_id = aws_route_table.private-route-table.id
  nat_gateway_id = aws_nat_gateway.nat-gateway-to-eip.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_internet_gateway" "generate-interet-gateway" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route" "interet-gateway-public-subnet" {
  route_table_id = aws_route_table.public-route-table.id
  gateway_id = aws_internet_gateway.generate-interet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}