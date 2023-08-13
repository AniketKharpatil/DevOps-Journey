output "vpc_id" { value = aws_vpc.main-vpc.id }

output "igw_id" { value = aws_internet_gateway.main-igw.id }

output "public_subnet_az1_id" {
  value = aws_subnet.public-subnet-az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public-subnet-az2.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private-subnet-az1.id,aws_subnet.private-subnet-az2.id]
}
