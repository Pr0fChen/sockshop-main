# Appel du module VPC
module "network" {
    source = "./modules/network"
    name = "sock-shop_vpc"
    cidr = "10.0.0.0/16"
    public_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
    private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
}

# Appel du module Bastion
module "bastion" {
    source = "./modules/bastion"
    allowed_cidr_blocks = ["0.0.0.0/0"]
    private_subnets = module.network.private_subnets
    public_subnets = module.network.public_subnets
    vpc_cidr_block = module.network.vpc_cidr_block
    vpc_id = module.network.vpc_id
    instance_type = "t2.medium"
    ami = "ami-00ac45f3035ff009e"
    cluster_security_group_id = module.kubernetes.eks_cluster_security_group_id
    depends_on = [
        module.network,
        module.kubernetes
        ]
    cluster_name = module.kubernetes.cluster_name
}

# Appel du module EKS
module "kubernetes" {
    source = "./modules/kubernetes"
    vpc_id = module.network.vpc_id
    private_subnets = module.network.private_subnets
    public_subnets = module.network.public_subnets
    lb_name = "test-lb-maintf"
    lb_tg_name = "ci-sockshop-k8s-tg"
    node_group_1_name = "node-group-1"
    node_group_2_name = "node-group-2"
    node_max_capacity = 3
    node_min_capacity = 1
    key_name = "eks_key"
    aws_amis = ""
    private_key_path = ""
    node_instance_type = ["t3.medium"]
    node_desired_capacity = 2
}

# Récupère les informations du cluster EKS après son déploiement
data "aws_eks_cluster" "cluster" {
  name = module.kubernetes.cluster_name
  depends_on = [module.kubernetes]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.kubernetes.cluster_name
  depends_on = [module.kubernetes]
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

# Provider Helm (attend que le cluster soit disponible)
# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

# Appel du module ADD-ons
module "add-ons" {
    source = "./modules/add-ons"
    region = var.region
    vpc_id = module.network.vpc_id
    private_subnets = module.network.private_subnets
    public_subnets = module.network.public_subnets
    cluster_name = module.kubernetes.cluster_name
    cluster_endpoint = module.kubernetes.eks_cluster_endpoint
    cluster_ca_certificate = module.kubernetes.eks_cluster_ca_certificate
    # cluster_token = module.kubernetes.eks_cluster_token
    cluster_oidc_provider = module.kubernetes.cluster_oidc_provider
    eks_cluster_id = module.kubernetes.eks_cluster_id
    oidc_provider_arn = module.kubernetes.oidc_provider_arn
    oidc_provider = module.kubernetes.oidc_provider
    depends_on = [
      module.network,
      module.kubernetes,
      module.bastion
      ]
}


# Appel du module de déploiement des applications
module "app" {
  source = "./modules/app"
  cluster_name = module.kubernetes.cluster_name
  cluster_endpoint = module.kubernetes.eks_cluster_endpoint
  cluster_ca_certificate = module.kubernetes.eks_cluster_ca_certificate
#   cluster_token = module.kubernetes.eks_cluster_token
  depends_on = [
    module.network,
    module.kubernetes,
    module.bastion
    ]
}

# module "prometheus" {
#   source = "./modules/prometheus"
#   cluster_name = module.kubernetes.cluster_name
#   cluster_endpoint = module.kubernetes.eks_cluster_endpoint
#   cluster_ca_certificate = module.kubernetes.eks_cluster_ca_certificate
#   cluster_token = module.kubernetes.eks_cluster_token
#   cluster_oidc_provider = module.kubernetes.cluster_oidc_provider
# }