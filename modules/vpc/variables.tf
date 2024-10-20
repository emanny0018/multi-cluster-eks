# modules/vpc/variables.tf

variable "region" {
  description = "AWS region where the VPC will be created"
  type        = string
}

variable "azs" {
  description = "Availability Zones for the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
}

