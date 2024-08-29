variable "lb_name" {}
variable "is_internal" {}
variable "lb_type" {}
variable "lb_sg" {}
variable "lb_subnet" {}
variable "target_group_arn" {}
variable "ec2_intance_id" {}
variable "target_group_attach_port" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
variable "lb_default_action_type" {}
variable "lb_https_listener_port" {}
variable "lb_https_listener_protocol" {}
variable "jenkins_acm_arn" {}

output "lb_dns_name" {
  value = aws_lb.jenkins_lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.jenkins_lb.zone_id
}

resource "aws_lb" "jenkins_lb" {
  name               = var.lb_name
  internal           = var.is_internal
  load_balancer_type = var.lb_type
  security_groups    = var.lb_sg
  subnets            = var.lb_subnet

  enable_deletion_protection = false

  tags = {
    Name = "Jenkins Load Balancer"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_lb_attach" {
  target_group_arn = var.target_group_arn
  target_id        = var.ec2_intance_id
  port             = var.target_group_attach_port
}

#for http
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_default_action_type
    target_group_arn = var.target_group_arn
  }
}

#https
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = var.lb_https_listener_port
  protocol          = var.lb_https_listener_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.jenkins_acm_arn

  default_action {
    type             = var.lb_default_action_type
    target_group_arn = var.target_group_arn
  }
}