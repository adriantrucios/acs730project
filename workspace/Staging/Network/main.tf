module "staging" {
  source              = "../../../modules/Network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  private_cidr_blocks = var.private_cidr_blocks
  public_cidr_blocks  = var.public_cidr_blocks
  prefix              = var.prefix
}