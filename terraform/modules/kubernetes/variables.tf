variable "cluster_name" {
  type    = string
  default = "sockshop-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.20"
}

variable "node_instance_type" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "node_max_capacity" {
  type    = number
  default = 3
}

variable "node_min_capacity" {
  type    = number
  default = 1
}

variable "key_name" {
  type    = string
  default = "your-key-name"
}

variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "aws_amis" {
  type    = string
  default = "ami-0c55b159cbfafe1f0" 
}

variable "private_key_path" {
  type    = string
}

# variable "node_group_name" {
#   description = "Name of the EKS node group"
#   type        = string
# }

variable "vpc_id" {
  type    = string
}

variable "private_subnets" {
  type    = list(string)
}
variable "node_group_1_name" {
  type    = string
  default = "node-group-1"
}

variable "node_group_2_name" {
  type    = string
  default = "node-group-2"
}

variable "public_subnets" {
  type    = list(string)
}

variable "lb_tg_name" {
  type    = string
  default = "ci-sockshop-k8s-tg"
}

variable "lb_name" {
  type    = string
  default = "ci-sockshop-k8s-elb"
}