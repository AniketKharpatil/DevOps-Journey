variable "vpc_id" {
  type= string
}
variable "priv_subnets" {
  type = list(string)
}
variable "public_subnet_az1_id" {
  type=string
}
