# output "ec2-bastion-public-key-path" {
#   value = local_file.ec2-bastion-host-public-key.filename
# }

# output "ec2-bastion-private-key-path" {
#   value = local_sensitive_file.ec2-bastion-host-private-key.filename
# }

# output "ec2-bastion-key-pair-name" {
#   value = aws_key_pair.ec2-bastion-host-key-pair.key_name
# }

# output "ec2-bastion-key-pair-public-key" {
#   value = aws_key_pair.ec2-bastion-host-key-pair.public_key
# }

# output "ec2-bastion-sg" {
#   value = aws_security_group.ec2-bastion-sg.id
# }

## ec2_bastion_instance_ids
# output "ec2_bastion_instance_ids" {
#   description = "Bastion Instance ID"
#   value       = module.ec2_bastion_instance.id
# }

## ec2_bastion_public_ip
output "bastion_instance_ip" {
  description = "Elastic IP associated to the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "private_key_pem" {
  description = "The private key for SSH access to the bastion host"
  value       = tls_private_key.my_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key for SSH access to the bastion host"
  value       = tls_private_key.my_key.public_key_openssh
}