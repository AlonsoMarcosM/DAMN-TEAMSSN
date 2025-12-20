output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}
