# modules/vpc/main.tf

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "shared-vpc"
  cidr = "10.0.0.0/16"       # IP range for the entire VPC
  azs  = var.azs             # Availability Zones where the VPC will be spread

  public_subnets  = var.public_subnets    # Public subnets (for load balancers, etc.)
  private_subnets = var.private_subnets   # Private subnets (for blue/green clusters)

  enable_nat_gateway = true               # Allows private subnets to access the internet
}

# Output the VPC ID and subnets for later use by other modules
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "blue_private_subnets" {
  # The first half of the private subnets is for the blue cluster
  value = slice(module.vpc.private_subnets, 0, length(module.vpc.private_subnets) / 2)
}

output "green_private_subnets" {
  # The second half of the private subnets is for the green cluster
  value = slice(module.vpc.private_subnets, length(module.vpc.private_subnets) / 2, length(module.vpc.private_subnets))
}

