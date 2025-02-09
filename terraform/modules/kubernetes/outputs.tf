output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "CA certificate of the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

# output "eks_cluster_token" {
#   description = "Token for the EKS cluster"
#   value       = data.aws_eks_cluster_auth.cluster.token
# }

output "eks_cluster_security_group_id" {
  description = "Security Group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "Security Group ID of the EKS nodes"
  value       = module.eks.node_security_group_id
}

# output "load_balancer_dns_name" {
#   description = "DNS name of the load balancer"
#   value       = aws_lb.ci-sockshop-k8s-elb.dns_name
# }

# output "load_balancer_arn" {
#   description = "ARN of the load balancer"
#   value       = aws_lb.ci-sockshop-k8s-elb.arn
# }

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "Security Group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_oidc_provider" {
  description = "OIDC provider of the EKS cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}