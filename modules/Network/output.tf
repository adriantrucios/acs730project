#public subnet output
output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}

#private subnet output
output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}

#vpc output
output "vpc_id" {
  value = aws_vpc.main.id
}