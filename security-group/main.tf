variable "sg_name" {}
variable "vpc_id" {}

output "sg_id" {
  value = aws_security_group.jenkins_sg.id
}

resource "aws_security_group" "jenkins_sg" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "To enable ports: 22(SSH), 80(HTTP), 443(HTTPS) and 8080(Jenkins)"

  #remote access 
  ingress {
    description = "To open port 22"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  #http traffic
  ingress {
    description = "To enable port 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  #https traffic
  ingress {
    description = "To enable port 443"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #jenkins port
  ingress {
    description = "To enable port 8080 for Jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  #outbound traffic
  egress {
    description = "Allow outgoing traffic"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "Jenkins Security Group"
  }

}