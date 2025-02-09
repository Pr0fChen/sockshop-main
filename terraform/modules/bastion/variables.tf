
variable "project" {
  type = string
  default = "sock-shop"
}

## VPC variables
variable "allowed_cidr_blocks" {
  description = "Les blocs CIDR autorisés à accéder au bastion"
  type        = list(string)
}

variable "private_subnets" {
  type = any
}

variable "public_subnets" {
  type = any
}

variable "vpc_id" {
  type = any
}

variable "vpc_cidr_block" {
  type = any
}

# EC2 Bastion Host variables
variable "ec2-bastion-public-key-path" {
  type = string
  default = "../secrets/ec2-bastion-key-pair.pub"
}

variable "ec2-bastion-private-key-path" {
  type = string
  default = "../secrets/ec2-bastion-key-pair.pem"
}

variable "ec2-bastion-ingress-ip-1" {
  type = string
  default = "0.0.0.0/0"
}

variable "bastion-bootstrap-script-path" {
  type = string
  default = "./bastion-boostrap.sh"
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}

variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "bastion-key"
}

variable "private_key_path" {
  description = "The path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
  default = "eu-west-3"
}

variable "cluster_security_group_id" {
  type = string
}