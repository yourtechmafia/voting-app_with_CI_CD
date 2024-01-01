variable "region" {
  description = "Preferred AWS Region"
  default     = "eu-west-2"  // Change as per your preferred region
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  default     = "appCluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}