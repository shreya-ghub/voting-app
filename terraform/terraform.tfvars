region = "us-east-1"

availability_zone = {
  public_subnet_az  = "us-east-1a"
  private_subnet_az = "us-east-1b"
}

cidr_block                = "10.0.0.0/16"
vpc_name                  = "voting-app-vpc"
public_subnet_cidr_block  = "10.0.1.0/24"
private_subnet_cidr_block = "10.0.2.0/24"
ami_image                 = "ami-0e2c8caa4b6378d8c"
instance_type             = "t2.micro"
inbound_rule              = "yes"