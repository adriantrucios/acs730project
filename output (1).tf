
output "public_subnet_ids_dev" {
  value = module.vpc-dev.public_subnet_ids
}

output "private_subnet_ids_dev" {
  value = module.vpc-dev.private_subnet_ids
}

output "vpc_id_dev" {
  value = module.vpc-dev.vpc_id
}


