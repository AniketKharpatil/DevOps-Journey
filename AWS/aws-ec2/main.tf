  # Get the latest Linux AMI 
  data "aws_ami" "amazon_linux" {
    most_recent = true

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    filter {
      name   = "name"
      values = ["amzn-ami-hvm*"] 
    }

    owners = ["amazon"] 
  }

  # keypair for public ec2 instance
  resource "aws_key_pair" "bastion_key" {
    key_name   = "bastion-key"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  # Security group for bastion host
  resource "aws_security_group" "bastion-sg" {  
    name        = "bastion"
    description = "SG for bastion host" 
    vpc_id      = var.vpc_id
    tags = {
      Name = "bastion-sg"
    }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
    }

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
      description = "Allow incoming SSH connections" 
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # Bastion host instance
  resource "aws_instance" "bastion" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids = [aws_security_group.bastion-sg.id]
    subnet_id = var.public_subnet_az1_id
    associate_public_ip_address = true
    monitoring = false
    tags = {
      Name = "Bastion Host" 
    }
  }

