resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "My Voting App VPC"
  }
}

resource "aws_subnet" "Mysubnet01" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet01_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    "Name" = "MyPublicSubnet01"
  }
}

resource "aws_subnet" "Mysubnet02" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet02_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true
  tags = {
    "Name" = "MyPublicSubnet02"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "MyIGW"
  }
}

resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "MyPublicRouteTable"
  }
}

resource "aws_route" "myigw_route" {
  route_table_id         = aws_route_table.myroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

resource "aws_route_table_association" "Mysubnet01_association" {
  route_table_id = aws_route_table.myroutetable.id
  subnet_id      = aws_subnet.Mysubnet01.id
}

resource "aws_route_table_association" "Mysubnet02_association" {
  route_table_id = aws_route_table.myroutetable.id
  subnet_id      = aws_subnet.Mysubnet02.id
}
