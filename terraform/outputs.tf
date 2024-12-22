##### Outputs for EC2 Instances #####
output "frontend_instance_public_ip" {
  description = "The public IP address of the 'frontend' EC2 instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_instance_public_ip" {
  description = "The public IP address of the 'backend' EC2 instance"
  value       = aws_instance.backend.public_ip
}

output "db_instance_public_ip" {
  description = "The public IP address of the 'DB' EC2 instance"
  value       = aws_instance.db.public_ip
}

##### Outputs for Subnets #####
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

##### Outputs for VPC #####
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.voting-app-vpc.id
}

##### Outputs for Security Groups #####
output "public_security_group_id" {
  description = "The ID of the public security group"
  value       = aws_security_group.public_security_group.id
}

output "private_security_group_id" {
  description = "The ID of the private security group"
  value       = aws_security_group.private_security_group.id
}
