module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  private_subnet_cidr  = var.private_subnet_cidr
  ap_availability_zone = var.ap_availability_zone
  public_subnet_cidr   = var.public_subnet_cidr

}

module "security-group" {
  source  = "./security-group"
  sg_name = "jenkins_sg"
  vpc_id  = module.networking.jenkins_vpc_id
}

module "jenkins-ec2" {
  source                    = "./jenkins-ec2"
  ami_id                    = var.ami_id
  instance_type             = "t2.medium"
  subnet_id                 = module.networking.public_subnet_id
  sg_id                     = module.security-group.sg_id
  pub_ip                    = true
  user_data_install_jenkins = templatefile("./jenkins_install/installer.sh", {})
  public_key                = var.public_key
}

module "lb-target-group" {
  source                   = "./lb-target-group"
  lb_target_group_name     = "Jenkins LB Target Group"
  lb_target_group_port     = 8080
  lb_target_group_protocol = "tcp"
  vpc_id                   = module.networking.jenkins_vpc_id
  ec2_intance_id           = module.jenkins-ec2.jenkins_instance_id

}

module "load-balancer" {
  source                     = "./load-balancer"
  lb_name                    = "jenkins_load_balancer"
  is_internal                = false
  lb_type                    = "application"
  lb_sg                      = module.security-group.sg_id
  lb_subnet                  = module.networking.public_subnet_id
  target_group_arn           = module.lb-target-group.lb_target_group_arn
  ec2_intance_id             = module.jenkins-ec2.jenkins_instance_id
  target_group_attach_port   = 8080
  lb_listener_port           = 80
  lb_listener_protocol       = "HTTP"
  lb_default_action_type     = "forward"
  lb_https_listener_port     = 443
  lb_https_listener_protocol = "HTTPS"
  jenkins_acm_arn            = ""

}

module "hosted-zone" {
  source         = "./hosted-zone"
  subdomain_name = "jenkins.infotex.digital"
  lb_dns_name    = module.load-balancer.lb_dns_name
  lb_zone_id     = module.load-balancer.lb_zone_id

}

# module "acm" {
#   source = ""

# }