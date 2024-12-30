##### Providers #####
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

##### VPC #####
resource "aws_vpc" "voting-app-vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

##### EC2 Instances #####
resource "aws_instance" "frontend" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  key_name                    = "voting-app-key"
  availability_zone           = "us-east-1a"
  vpc_security_group_ids      = [aws_security_group.public_security_group.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "backend" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  key_name                    = "voting-app-key"
  availability_zone           = "us-east-1b"
  vpc_security_group_ids      = [aws_security_group.private_security_group.id]
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "db" {
  ami                         = var.ami_image
  instance_type               = var.instance_type
  key_name                    = "voting-app-key"
  availability_zone           = "us-east-1b"
  vpc_security_group_ids      = [aws_security_group.private_security_group.id]
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  tags = {
    Name = "db"
  }
}

##### Subnets #####

# Public # 
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.voting-app-vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone["public_subnet_az"]
  tags = {
    Name = "public_subnet"
  }
}

# Private #
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.voting-app-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone["private_subnet_az"]
  cidr_block              = var.private_subnet_cidr_block
  tags = {
    Name = "private_subnet"
  }
}

##### Security Groups #####

# Public #
resource "aws_security_group" "public_security_group" {
  name        = "voting-app_public-sec-gr"
  description = "Allow public traffic"
  vpc_id      = aws_vpc.voting-app-vpc.id

  ingress {
    description = "TLS from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http from Internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http from Internet"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "PostgreSQL from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = []
    security_groups = [aws_security_group.private_security_group.id]
  }

  tags = {
    Name = "voting-app_public-sec-gr"
  }
}

# Private #
resource "aws_security_group" "private_security_group" {
  name        = "voting-app_private-sec-gr"
  description = "Allow private traffic "
  vpc_id      = aws_vpc.voting-app-vpc.id

  # Allow SSH from the frontend EC2 instance to backend and db instances
  ingress {
  description     = "Allow SSH from Frontend EC2"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = []
  security_groups = [aws_security_group.public_security_group.id]
}

  ingress {
  description     = "Allow communication with backend and DB instances"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  security_groups = [aws_security_group.public_security_group.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "voting-app_private-sec-gr"
  }
}