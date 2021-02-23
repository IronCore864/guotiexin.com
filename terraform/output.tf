output "load_balancer_controller_role_arn" {
  value = module.load_balancer_controller_role.lbc_iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external_dns_role.external_dns_iam_role_arn
}

output "external_secrets_role_arn" {
  value = module.external_secrets_role.external_secrets_role_arn
}

output "waf_regional_web_acl_arn" {
  value = module.waf.waf_regional_web_acl_arn
}
