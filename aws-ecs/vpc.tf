module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ECS VPC"
  cidr = "192.170.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets  = ["192.170.0.0/24", "192.170.1.0/24", "192.170.2.0/24"]
  enable_dns_hostnames = true
  map_public_ip_on_launch = true
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

