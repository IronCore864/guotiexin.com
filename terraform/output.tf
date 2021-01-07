output "load_balancer_controller_role_arn" {
  value = module.load-balancer-controller-role.lbc_iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external-dns-role.external_dns_iam_role_arn
}

output "waf_regional_web_acl_arn" {
  value = module.waf.waf_regional_web_acl_arn
}

output "global_accelerator_dns_name" {
  value = module.global-accelerator.dns_name
}
