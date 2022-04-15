output "public_subnet_ids" {
  value = module.prod.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.prod.private_subnet_ids
}

output "vpc_id" {
  value = module.prod.vpc_id
}