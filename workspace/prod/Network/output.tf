output "public_subnet_ids" {
  value = module.prod.public_subnet
}

output "private_subnet_ids" {
  value = module.prod.private_subnet
}

output "vpc_id" {
  value = module.prod.vpc_id
}