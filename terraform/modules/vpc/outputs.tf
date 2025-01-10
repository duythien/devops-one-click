
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
