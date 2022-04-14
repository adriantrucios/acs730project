output "public_subnet_ids" {
  value = module.dev.public_subnet
}

output "private_subnet_ids" {
  value = module.dev.private_subnet
}

output "vpc_id" {
  value = module.dev.vpc_id
}