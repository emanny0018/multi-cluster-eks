# main.tf

provider "aws" {
  region = "us-east-1"   # This is the AWS region where resources will be created
}

# Create the shared VPC (used by both blue and green EKS clusters)
module "vpc" {
  source  = "./modules/vpc"
  region  = "us-east-1"                       # AWS region for the VPC
  azs     = ["us-east-1a", "us-east-1b"]      # Availability Zones for high availability

  # Public subnets (shared by both blue and green clusters)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  # Private subnets (split between blue and green clusters)
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# Create the Blue EKS Cluster (using its dedicated private subnets)
module "eks_blue" {
  source          = "./modules/eks"
  cluster_name    = "blue-cluster"             # Name of the blue cluster
  cluster_version = "1.29"                     # Kubernetes version

  vpc_id          = module.vpc.vpc_id          # VPC ID from the VPC module
  subnets         = module.vpc.blue_private_subnets  # Blue's private subnets
  region          = "us-east-1"                # AWS region
  instance_type   = "t2.medium"                # Instance type for worker nodes
}

# Create the Green EKS Cluster (using its dedicated private subnets)
module "eks_green" {
  source          = "./modules/eks"
  cluster_name    = "green-cluster"            # Name of the green cluster
  cluster_version = "1.29"                     # Kubernetes version

  vpc_id          = module.vpc.vpc_id          # VPC ID from the VPC module
  subnets         = module.vpc.green_private_subnets # Green's private subnets
  region          = "us-east-1"                # AWS region
  instance_type   = "t2.medium"                # Instance type for worker nodes
}

