variable "cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "voting-app-vpc" {
  type        = string
  description = "voting-app-vpc"
  default     = "yes"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "voting-app-vpc"
}

variable "public_subnet_cidr_block" {
  type        = string
  default     = "10.0.1.0/24"
  description = "cidr range for public subnet"
}

variable "private_subnet_cidr_block" {
  type        = string
  default     = "10.0.2.0/24"
  description = "cidr range for private subnet"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "default region where infrastructures will be provisioned"
}

variable "availability_zone" {
  type = map(string)
  default = {
    public_subnet_az  = "us-east-1a"
    private_subnet_az = "us-east-1b"
  }
}

variable "ami_image" {
  type    = string
  default = "ami-0e2c8caa4b6378d8c"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "inbound_rule" {
  description = "Enable inboud rule"
  type        = string
  default     = "yes"
}

variable "subnets" {
  description = "List of subnets"
  type        = list(string)
  default     = ["public_subnet", "private_subnet"]
}