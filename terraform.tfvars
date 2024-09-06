#networking
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "Jenkins VPC"
private_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidr   = ["10.0.3.0/24", "10.0.4.0/24"]
ap_availability_zone = ["ap-south-1a", "ap-south-1b"]

#ec2
ami_id     = "ami-0522ab6e1ddcc7055"
public_key = ${{env.PUBLIC_KEY}}

