# Backend configuration to store state in S3 and lock state in DynamoDB
terraform {
  backend "s3" {
    bucket         = "etl-pipeline-manny"              # Your S3 bucket for storing state
    key            = "${terraform.workspace}/terraform.tfstate"  # Workspace-specific state file
    region         = "us-east-2"                       # S3 bucket and DynamoDB region
    dynamodb_table = "tf_state_lock"                   # DynamoDB table for state locking
    encrypt        = true                              # Encrypt state file at rest
  }
}

# AWS Provider
provider "aws" {
  region = "us-east-2"  # The AWS region for your resources (VPC, EKS, etc.)
}

# VPC Module (shared between both blue and green EKS clusters)
module "vpc" {
  source  = "./modules/vpc"  # Path to the VPC module
  region  = "us-east-2"      # AWS region for the VPC
  azs     = ["us-east-2a", "us-east-2b"]  # Availability Zones for high availability

  # Define the public and private subnets
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]    # Public subnets
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]    # Private subnets

  # Other optional VPC settings can go here if needed, like NAT gateways, etc.
}

# EKS Blue Cluster Configuration
module "eks_blue" {
  source          = "./modules/eks"         # Path to the EKS module
  cluster_name    = "blue-cluster"           # Name of the blue EKS cluster
  cluster_version = "1.29"                  # Kubernetes version for the EKS cluster

  vpc_id          = module.vpc.vpc_id        # VPC ID from the VPC module
  subnets         = module.vpc.private_subnets  # Blue EKS cluster private subnets
  instance_type   = "t2.medium"              # EC2 instance type for worker nodes
  region          = "us-east-2"              # AWS region
}

# EKS Green Cluster Configuration
module "eks_green" {
  source          = "./modules/eks"         # Path to the EKS module
  cluster_name    = "green-cluster"          # Name of the green EKS cluster
  cluster_version = "1.29"                  # Kubernetes version for the EKS cluster

  vpc_id          = module.vpc.vpc_id        # VPC ID from the VPC module
  subnets         = module.vpc.private_subnets  # Green EKS cluster private subnets
  instance_type   = "t2.medium"              # EC2 instance type for worker nodes
  region          = "us-east-2"              # AWS region
}

# Outputs: Display the API endpoints for both clusters
output "blue_cluster_endpoint" {
  value = module.eks_blue.cluster_endpoint
}

output "green_cluster_endpoint" {
  value = module.eks_green.cluster_endpoint
}

