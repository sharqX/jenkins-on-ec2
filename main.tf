module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  private_subnet_cidr  = var.private_subnet_cidr
  ap_availability_zone = var.ap_availability_zone
  public_subnet_cidr   = var.public_subnet_cidr

}

module "security-group" {
  source = "./security-group"
  sg_name = "jenkins_sg"
  vpc_id = module.networking.jenkins_vpc_id
}

# module "jenkins-ec2" {
#   source = ""

# }

# module "lb-target-group" {
#   source = ""

# }

# module "load-balancer" {
#   source = ""

# }

# module "hosted-zone" {
#   source = ""

# }

# module "acm" {
#   source = ""

# }