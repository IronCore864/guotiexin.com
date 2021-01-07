output "waf_cf_web_acl_arn" {
  value = aws_wafv2_web_acl.cf_managed_rules_default.arn
}

output "waf_regional_web_acl_arn" {
  value = aws_wafv2_web_acl.regional_managed_rules_default.arn
}