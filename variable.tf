#networking
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR value"
}
variable "vpc_name" {
  type        = string
  description = "VPC Name"
}
variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private Subnet CIDR Value"
}
variable "ap_availability_zone" {
  type        = list(string)
  description = "Availibility Zones"
}
variable "public_subnet_cidr" {
  type        = list(string)
  description = "Pulic Subnet CIDR Value"
}

#ec2
variable "ami_id" {
  type        = string
  description = "ami id for ec2 instance"
}

variable "public_key" {
  type        = string
  description = "Public key value"
}