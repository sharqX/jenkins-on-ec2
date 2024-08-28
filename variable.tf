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
  type        = string
  description = "Private Subnet CIDR Value"
}
variable "ap_availability_zone" {
  type        = string
  description = "Availibility Zones"
}
variable "public_subnet_cidr" {
  type        = string
  description = "Pulic Subnet CIDR Value"
}
