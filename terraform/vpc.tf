resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "voting-app-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidrs)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "voting-app-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}