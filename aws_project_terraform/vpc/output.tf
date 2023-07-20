output "vpc_id" { value = aws_vpc.main-vpc.id }

output "igw_id" { value = aws_internet_gateway.main-igw.id }
