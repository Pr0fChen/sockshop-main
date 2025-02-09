variable "cluster_name" {
  type    = string
  default = "sockshop-cluster"
}

variable "vpc_id" {
  type    = string
}

variable "private_subnets" {
  type    = list(string)
}

variable "public_subnets" {
  type    = list(string)
}

variable "oidc_provider" {
  type = any
}

variable "oidc_provider_arn" {
  type = any
}

variable "eks_cluster_id" {
  type = any
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster"
  type        = string
}

# variable "cluster_token" {
#   description = "Token for the EKS cluster"
#   type        = string
# }

variable "cluster_oidc_provider" {
  description = "OIDC provider of the EKS cluster"
  type        = string
}

data "aws_caller_identity" "current" {}

variable "region" {
  type = any
}