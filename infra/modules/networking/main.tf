// Networking module: VPC, public subnet, and default route to the internet.

// VPC for the lab.
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.project_prefix}-vpc-${var.resource_suffix}"
  })
}

// Internet gateway for outbound access.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_prefix}-igw-${var.resource_suffix}"
  })
}

// Public route table.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_prefix}-rt-public-${var.resource_suffix}"
  })
}

// Default route to the internet.
resource "aws_route" "default_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

// Public subnet where EC2 will live.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_prefix}-subnet-public-${var.resource_suffix}"
  })
}

// Associate subnet with the public route table.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
