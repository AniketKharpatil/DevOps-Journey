 # Provider for aws
  provider "aws" {
    region = "us-east-1"
    access_key = "access_key"
    secret_key = "sceret_key"
  }
  

 # module for vpc
 module "vpc" {
    source = "./vpc"
 }

 module "auto-scaling" {
    source = "./auto-scaling"
    vpc_id=module.vpc.vpc_id
    subnets = module.vpc.private_subnet_ids
    public_subnet_az1_id = module.vpc.public_subnet_ids[0]
 }
