module "network" {
  source = "./network"

  vpc_cidr        = var.vpc_cidr
  provider_region = var.provider_region
  subnet_public1  = var.subnet_public1
  subnet_public2  = var.subnet_public2
  subnet_private1 = var.subnet_private1
  subnet_private2 = var.subnet_private2

}