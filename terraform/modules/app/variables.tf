variable "cluster_name" {
  description = "Namespace of the EKS cluster"
  type        = string
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