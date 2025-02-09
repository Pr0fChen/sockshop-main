# recupère dynamiquement les zones de disponibilités
data "aws_availability_zones" "available" {}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = var.name
  cidr               = var.cidr
  azs                = data.aws_availability_zones.available.names
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  enable_vpn_gateway = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
