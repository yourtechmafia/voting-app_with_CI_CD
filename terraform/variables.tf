variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet01_cidr" {
  description = "CIDR for Subnet 01"
  default     = "10.0.1.0/24"
}

variable "subnet02_cidr" {
  description = "CIDR for Subnet 02"
  default     = "10.0.2.0/24"
}

variable "availability_zone_a" {
  description = "Availability Zone A"
  default     = "eu-west-2a"
}

variable "availability_zone_b" {
  description = "Availability Zone B"
  default     = "eu-west-2b"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.small"
}

variable "disk_size" {
  description = "Nodes disk size"
  default     = "20"
}

# Add other variables as needed
