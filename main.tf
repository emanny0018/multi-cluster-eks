terraform {
  backend "s3" {
    bucket         = "etl-pipeline-manny"     # Repplace with your actual S3 bucket
    key            = "dev/terraform.tfstate"  # Workspace-specific state file
    region         = "us-east-2"                       # The region where your S3 bucket is located
    dynamodb_table = "tf_state_lock"                 # DynamoDB table for state locking
    encrypt        = true                              # Ensure the state is encrypted at rest
  }
}

provider "aws" {
  region = "us-east-1"   # AWS region where resources will be created
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

  # Output values for blue and green subnets (can be defined in the VPC module)
  blue_private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]   # Subnets for Blue Cluster
  green_private_subnets = ["10.0.5.0/24", "10.0.6.0/24"]   # Subnets for Green Cluster
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

