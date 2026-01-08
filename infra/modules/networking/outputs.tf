// VPC id.
output "vpc_id" {
  value = aws_vpc.this.id
}

// Public subnet id.
output "subnet_id" {
  value = aws_subnet.public.id
}

// Public route table id.
output "route_table_id" {
  value = aws_route_table.public.id
}

// Internet gateway id.
output "igw_id" {
  value = aws_internet_gateway.this.id
}
