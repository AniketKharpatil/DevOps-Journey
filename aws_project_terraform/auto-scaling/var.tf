variable "vpc_id" {
  type= string
}
variable "subnets" {
  type = list(string)
}
variable "public_subnet_az1_id" {
  type=string
}