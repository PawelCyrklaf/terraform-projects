module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = toset(var.azs)
  public_subnets          = toset(var.public_subnets_cidrs)
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_vpn_gateway      = false
}

