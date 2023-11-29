output "output_aws_vpc" {
 value = aws_vpc.production_vpc.id
}

output "ouput-public-subnet" {
 value = aws_subnet.public-subnet.id 
}