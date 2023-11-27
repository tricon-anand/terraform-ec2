resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

output "output_aws_vpc" {
 value = aws_vpc.main.id
}

resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public" {
  count                  = length(var.availability_zones)
  cidr_block             = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone      = var.availability_zones[count.index]
  vpc_id                 = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                  = length(var.availability_zones)
  cidr_block             = cidrsubnet(var.cidr_block, 8, count.index + 2)
  availability_zone      = var.availability_zones[count.index]
  vpc_id                 = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "demo_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

output "output_subnet" {
  value = aws_subnet.demo_subnet.id
}