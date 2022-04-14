output "public_subnet_ids" {
  value = module.staging.public_subnet
}

output "private_subnet_ids" {
  value = module.staging.private_subnet
}

output "vpc_id" {
  value = module.staging.vpc_id
}