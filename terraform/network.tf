resource "aws_vpc" "ecommerce" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ecommerce-vpc"
  }
}

resource "aws_internet_gateway" "ecommerce" {
  vpc_id = aws_vpc.ecommerce.id

  tags = {
    Name = "ecommerce-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ecommerce.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecommerce-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecommerce.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce.id
  }

  tags = {
    Name = "ecommerce-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
