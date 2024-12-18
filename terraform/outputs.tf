##### Outputs for EC2 Instances #####
output "vote_instance_public_ip" {
  description = "The public IP address of the 'vote' EC2 instance"
  value       = aws_instance.vote.public_ip
}

output "result_instance_public_ip" {
  description = "The public IP address of the 'result' EC2 instance"
  value       = aws_instance.result.public_ip
}

output "worker_instance_public_ip" {
  description = "The public IP address of the 'worker' EC2 instance"
  value       = aws_instance.worker.public_ip
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
