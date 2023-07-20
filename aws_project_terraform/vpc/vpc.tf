  # Create VPC
  resource "aws_vpc" "main-vpc" {
      cidr_block = "10.0.0.0/16"
  }

  # Create public and private subnets
    
  # Create public subnet in AZ1
  resource "aws_subnet" "public-subnet-az1" {
      vpc_id            = aws_vpc.main-vpc.id
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
  }

  # Create public subnet in AZ2  
  resource "aws_subnet" "public-subnet-az2" {
      vpc_id            = aws_vpc.main-vpc.id  
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
  }

  # Create private subnet in AZ1
  resource "aws_subnet" "private-subnet-az1" {
      vpc_id            = aws_vpc.main-vpc.id  
      cidr_block        = "10.0.3.0/24"  
      availability_zone = "us-east-1a"
  }

  # Create private subnet in AZ2
  resource "aws_subnet" "private-subnet-az2" {
      vpc_id            = aws_vpc.main-vpc.id  
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"      
  }

  # Create Internet Gateway
  resource "aws_internet_gateway" "main-igw" {
      vpc_id = aws_vpc.main-vpc.id
  }

  # Create public route table
  resource "aws_route_table" "public-rtb" {
    vpc_id = aws_vpc.main-vpc.id
    route {
      cidr_block = "0.0.0.0/0"  
      gateway_id = aws_internet_gateway.main-igw.id 
    }
  }

  # Association of public route table

  # Associate public route table with public subnets
  resource "aws_route_table_association" "public-rtba-az1" {
    subnet_id      = aws_subnet.public-subnet-az1.id
    route_table_id = aws_route_table.public-rtb.id 
  }

  resource "aws_route_table_association" "public_rtba-az2" {
    subnet_id      = aws_subnet.public-subnet-az2.id
    route_table_id = aws_route_table.public-rtb.id
  }

  # Create and Associate private route tables

  # Create private route table for AZ 1
  resource "aws_route_table" "private-rtb-az1" {
    vpc_id = aws_vpc.main-vpc.id  
  }

  # Create private route table for AZ 2
  resource "aws_route_table" "private-rtb-az2" {
    vpc_id = aws_vpc.main-vpc.id
  }  

  # Associate private route table 1 with AZ1 private subnet
  resource "aws_route_table_association" "private-rtba-az1" {
    subnet_id      = aws_subnet.private-subnet-az1.id
    route_table_id = aws_route_table.private-rtb-az1.id
  }

  # Associate private route table 2 with AZ2 private subnet
  resource "aws_route_table_association" "private-rtba-az2" {
    subnet_id      = aws_subnet.private-subnet-az2.id
    route_table_id = aws_route_table.private-rtb-az2.id
  }
