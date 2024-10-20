# modules/eks/main.tf

provider "aws" {
  region = var.region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id  = var.vpc_id
  subnets = var.subnets               # Pass the correct subnets (blue or green)

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = var.instance_type
    }
  }
}

# Output the EKS cluster's API endpoint
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

