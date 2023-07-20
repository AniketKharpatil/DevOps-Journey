 # Provider for aws
  provider "aws" {
    region = "us-east-1"
    access_key = "my-access-key"
    secret_key = "my-secret-key"
  }
  

 # module for vpc
 module "main-vpc" {
    source = "./vpc"
 }

 module "auto-scaling" {
    source = "./auto-scaling"
 }
