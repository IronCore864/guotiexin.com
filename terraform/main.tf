module "network" {
  source = "../modules/networking"

  vpc_cidr_block  = var.main_vpc_cidr
  vpc_name        = var.main_vpc_name
  public_subnets  = var.main_vpc_public_subnets
  private_subnets = var.main_vpc_private_subnets
}

module "r53" {
  source = "../modules/r53"

  zone_name = var.zone_name
}

module "wordpress-db" {
  source = "../modules/aurora"

  db_subnet_ids       = module.network.private_subnet_ids
  vpc_id              = module.network.vpc_id
  allow_inbound_cidrs = values(var.main_vpc_private_subnets)
}

module "waf" {
  source = "../modules/wafv2"
}

module "load-balancer-controller-role" {
  source = "../modules/load-balancer-controller-role"

  oidc_provider = var.eks_oidc_provider_url
}

module "external-dns-role" {
  source = "../modules/external-dns-role"

  oidc_provider = var.eks_oidc_provider_url
}

module "wordpress-cf" {
  source = "../modules/cloudfront"

  web_acl_id         = module.waf.waf_cf_web_acl_arn
  origin_domain_name = var.eks_alb_dns
}
