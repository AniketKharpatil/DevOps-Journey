output "vpc_id" { value = aws_vpc.main-vpc.id }

output "public_subnet_az1_id" { value = aws_subnet.public-subnet-az1.id }

output "public_subnet_az2_id" { value = aws_subnet.public-subnet-az2.id }

output "private_subnet_az1_id" { value = aws_subnet.private-subnet-az1.id }

output "private_subnet_az2_id" { value = aws_subnet.private-subnet-az2.id }

output "igw_id" { value = aws_internet_gateway.main-igw.id }

output "public_rt_id" { value = aws_route_table.public-rtb.id }

output "private_rt_az1_id" { value = aws_route_table.private-rtb-az1.id }

output "private_rt_az2_id" { value = aws_route_table.private-rtb-az2.id }