# ALB Security Group
  resource "aws_security_group" "alb_sg" {  
    name        = "alb-sg"   
    description = "Security group for ALB"
    vpc_id      = var.vpc_id
    tags = {
      Name = "ALB-SG"
    }

    ingress {
      from_port   = 80
      to_port     = 80 
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
      from_port   = 0    
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # ALB
  resource "aws_lb" "app_lb" {
    name               = "app-lb"
    internal           = false
    load_balancer_type = "application"
    subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  }

  # Create target group for instances in private subnets
  resource "aws_lb_target_group" "private_tg" {
    name     = "private-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
  }

  # Register ASG instances with target group
  resource "aws_autoscaling_attachment" "asg_attach_lb" {
    autoscaling_group_name = var.private_asg_id
    lb_target_group_arn   = aws_lb_target_group.private_tg.arn
  }

  # Create internal load balancer listener
  resource "aws_lb_listener" "internal_alb_listener" { 
    load_balancer_arn = aws_lb.app_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.private_tg.arn
    }
  }