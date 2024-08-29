variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "pub_ip" {}
variable "user_data_install_jenkins" {}
variable "public_key" {}

output "jenkins_instance_id" {
  value = aws_instance.jenkins_ec2.id
}

resource "aws_instance" "jenkins_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Jenkins EC2"
  }

  key_name                    = "ec2_key"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = var.pub_ip

  user_data = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

resource "aws_key_pair" "ec2_key_name" {
  key_name   = "ec2_key"
  public_key = var.public_key
}