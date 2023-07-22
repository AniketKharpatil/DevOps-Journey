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
    monitoring = false
    tags = {
      Name = "Bastion Host" 
    }
  }


  # ASG------------------------------------------------------------------------------------

  
  # Security group for ASG instances
  resource "aws_security_group" "asg_SecurityGroup" {  
    name        = "asg-instances"
    description = "SG for ASG instances"
    vpc_id      = var.vpc_id
    tags = {
      Name = "ASG-SecurityGroup" 
    }

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow incoming SSH connections" 
    }
  }

  # Launch configuration
  resource "aws_launch_configuration" "lc" {
    name_prefix     = "terraform-lc"
    image_id        = data.aws_ami.amazon_linux.id
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.asg_SecurityGroup.id]

    # can bring you cost if enabled
    enable_monitoring = false

    lifecycle {
      create_before_destroy = true  
    }
  }

  # Auto scaling group
  resource "aws_autoscaling_group" "private_asg" {
    name                 = "terraform-asg"
    launch_configuration = aws_launch_configuration.lc.name
    vpc_zone_identifier = var.subnets

    min_size = 2
    max_size = 4

    tag {
      key                 = "Name"
      value               = "private-asg-instance"
      propagate_at_launch = true
    }
  }
