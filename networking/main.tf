variable "vpc_cidr" {}
variable "vpc_name" {}
variable "private_subnet_cidr" {}
variable "ap_availability_zone" {}
variable "public_subnet_cidr" {}

output "jenkins_vpc_id" {
  value = aws_vpc.jenkins_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.jenkins_public_subnet.*.id
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "jenkins_public_subnet" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.jenkins_vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)

  tags = {
    Name = "Jenkins Public Subnet-$(count.index + 1)"
  }
}

resource "aws_subnet" "jenkins_private_subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.jenkins_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.ap_availability_zone, count.index)

  tags = {
    Name = "Jenkins Private Subnet-$(count.index + 1)"
  }
}


resource "aws_internet_gateway" "jenkins_ig" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "Jenkins Internet Gateway"
  }
}

resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_ig.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_rta" {
  count          = length(aws_subnet.jenkins_public_subnet)
  subnet_id      = aws_subnet.jenkins_public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "Private Subnet Route Table"
  }
}

resource "aws_route_table_association" "private_subnet_rta" {
  count          = length(aws_subnet.jenkins_private_subnet)
  subnet_id      = aws_subnet.jenkins_private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_rt.id
}
