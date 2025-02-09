variable "cluster_name" {
  type        = string
}

variable "namespace" {
  type        = string
  default     = "prometheus"
}

variable "prometheus_version" {
  type        = string
  default     = "45.7.1"
}

variable "helm_release_name" {
  type        = string
  default     = "prometheus"
}
variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster"
  type        = string
}

variable "cluster_token" {
  description = "Token for the EKS cluster"
  type        = string
}

variable "cluster_oidc_provider" {
  description = "OIDC provider of the EKS cluster"
  type        = string
}

data "aws_caller_identity" "current" {}