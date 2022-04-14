
output "public_subnet_ids_staging" {
  value = module.vpc-staging.public_subnet_ids
}

output "private_subnet_ids_staging" {
  value = module.vpc-staging.private_subnet_ids
}

output "vpc_id_staging" {
  value = module.vpc-staging.vpc_id
}


