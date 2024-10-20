# modules/eks/variables.tf

variable "region" {
  description = "AWS region where the EKS cluster will be created"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version to use"
  default     = "1.29"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "The private subnets for the EKS cluster"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for worker nodes"
  default     = "t2.medium"
  type        = string
}

